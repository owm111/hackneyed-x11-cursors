/*
 * Copyright (C) Richard Ferreira
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR THE COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Except as contained in this notice, the name(s) of the above copyright
 * holders shall not be used in advertising or otherwise to promote the sale,
 * use or other dealings in this Software without prior written authorization.
 */
 
 /* ico2cur.c: convert a Windows icon (.ico) file to a cursor (.cur) file */

#if defined __GNUC__ && !defined _GNU_SOURCE
# define _GNU_SOURCE
#endif

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <getopt.h>
#include <stdarg.h>
#include <errno.h>

#define HEADERLEN	13

void die(const char *msg, ...)
{
	va_list argp;
	
	va_start(argp, msg);
	vfprintf(stderr, msg, argp);
	putc('\n', stderr);
	va_end(argp);
	exit(EXIT_FAILURE);
}

unsigned short get_axis(const char *s, char axis)
{
	short ret;
	char *tail;
	
	ret = strtol(s, &tail, 0);
	if (ret < 0 || ret > 31 || s == tail)
		die("invalid value for %c: %s", axis, s);
	return ret;
}

char *get_destfname(const char *orig)
{
	char *ret = NULL;
	char *dot = NULL;
	long namelen = strlen(orig) + 5;
	
	if (!(ret = malloc(namelen)))
		die("malloc error");
	
	dot = strrchr(orig, '.');
	memcpy(ret, orig, dot ? dot - orig : namelen - 5);
	strncat(ret, ".cur", namelen - strlen(ret) - 1);
	return ret;
}

int main(int argc, char **argv)
{
	FILE *fsrc, *fdest;
	size_t b;
	int c;
	unsigned short x, y;
	char buf[BUFSIZ] = "";
	char header[HEADERLEN] = "";
	char *src = NULL;
	char *dest = NULL;
	
	x = y = 0;
	while ((c = getopt(argc, argv, "x:y:h")) != -1) {
		switch (c) {
		case 'x':
			x = get_axis(optarg, c);
			break;
		case 'y':
			y = get_axis(optarg, c);
			break;
		case 'h':
			die("usage: ico2cur <infile.ico> -x x_axis -y y_axis");
			break;
		default:
			exit(EXIT_FAILURE);
		}
	}
	if (argc > optind)
		src = argv[optind];
	else
		die("no filename specified");
	if (!(fsrc = fopen(src, "r")))
		die("%s: %s", src, strerror(errno));
	fread(header, sizeof(char), sizeof(header), fsrc);
	if (ferror(fsrc))
		die("%s: could not read file", src);
	/* A kind of magic */
	header[2] = (char)2;
	header[10] = (char)x;
	header[12] = (char)y;
	dest = get_destfname(src);
	if (!(fdest = fopen(dest, "w+")))
		die("%s: %s", dest, strerror(errno));
	fwrite(header, sizeof(char), sizeof(header), fdest);
	while ((b = fread(buf, sizeof(char), sizeof(buf), fsrc)))
		fwrite(buf, sizeof(char), b, fdest);
	free(dest);
	fclose(fsrc);
	fclose(fdest);
	return 0;
}
