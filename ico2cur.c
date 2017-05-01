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

char *extsub(const char *orig, const char *new_ext)
{
	char *ret = NULL;
	char *dot = NULL;
	long namelen = strlen(orig) + 5;
	
	if (!(ret = malloc(namelen)))
		die("malloc error");
	memset(ret, 0, namelen - 1);
	dot = strrchr(orig, '.');
	memcpy(ret, orig, dot ? dot - orig : namelen - 5);
	if (new_ext)
		strncat(ret, new_ext, namelen - strlen(ret) - 1);
	return ret;
}

int is_forbidden(const char *blacklist, int c)
{
	for (; *blacklist; blacklist++)
		if (c == *blacklist)
			return 0;
	return -1;
}

char *strbtrim(char *s, const char *forbidden)
{
	char *p, *begin = s;
	size_t len;

	p = s;
	while (*p && is_forbidden(forbidden, *p) == 0)
		p++;
	len = strlen(p);
	memmove(s, p, len);
	s[len] = 0;
	p = strchr(s, 0) - 1;
	while (p >= begin && is_forbidden(forbidden, *p) == 0) {
		*p = 0;
		p--;
	}
	return begin;
}

void get_hotspot(const char *src, const char *name, unsigned short *x, unsigned short *y)
{
	FILE *f = fopen(src, "r");
	char buf[BUFSIZ] = "";
	char *sx, *sy, *tail;

	if (!f)
		die("fopen: %s", src);
	while (fgets(buf, sizeof(buf), f)) {
		if (*buf == '#' || *buf == ';')
			continue;
		strbtrim(buf, "\n\t ");
		if (!(sx = strchr(buf, '\t')))
			continue;
		*sx = 0;
		sx++;
		if (strcmp(buf, name))
			continue;
		strbtrim(sx, "\n\t ");
		if (!(sy = strchr(sx, ' ')))
			continue;
		*sy = 0;
		sy++;
		*x = strtol(sx, &tail, 0);
		if (*x > 31 || sx == tail)
			die("%s: invalid x axis: %s", buf, sx);
		*y = strtol(sy, &tail, 0);
		if (*y > 31 || sy == tail)
			die("%s: invalid y axis: %s", buf, sy);
		fclose(f);
		return;
	}
	die("%s not found in %s", name, src);
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
	char *p;
	char *hotspotsrc = NULL, *name = NULL;
	
	x = y = 0;
	while ((c = getopt(argc, argv, "x:y:hp:")) != -1) {
		switch (c) {
		case 'x':
			x = get_axis(optarg, c);
			break;
		case 'y':
			y = get_axis(optarg, c);
			break;
		case 'h':
			die("usage: ico2cur <infile.ico> -x x_axis -y y_axis -n name -p hotspotsrc");
			break;
		case 'p':
			hotspotsrc = strdup(optarg);
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
	if (hotspotsrc) {
		strncpy(buf, src, sizeof(buf));
		p = basename(buf);
		name = extsub(p, NULL);
		get_hotspot(hotspotsrc, name, &x, &y);
		printf("%s: (%d,%d)\n", name, x, y);
		free(name);
		free(hotspotsrc);
	}
	/* A kind of magic */
	header[2] = (char)2;
	header[10] = (char)x;
	header[12] = (char)y;
	dest = extsub(src, ".cur");
	if (!(fdest = fopen(dest, "w+")))
		die("%s: %s", dest, strerror(errno));
	fwrite(header, sizeof(char), sizeof(header), fdest);
	while ((b = fread(buf, sizeof(char), sizeof(buf), fsrc)))
		fwrite(buf, sizeof(char), b, fdest);
	printf("%s -> %s\n", src, dest);
	free(dest);
	fclose(fsrc);
	fclose(fdest);
	return 0;
}
