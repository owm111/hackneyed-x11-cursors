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
 
 /* png2cur.c: convert a PNG file to a cursor (.cur) file
  * requires: libpng >= 1.6.36
  * 
  * note: PNG-based cursors require Windows Vista and later */

#if defined __GNUC__ && !defined _GNU_SOURCE
# define _GNU_SOURCE
#endif

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <getopt.h>
#include <stdlib.h>
#include <errno.h>
#include <png.h>

#define ICONMAX		1024
#define PNG_BYTES	8

typedef struct {
	uint8_t width;
	uint8_t height;
	uint8_t colors; /* colors in the image (0 if >=8bpp) */
	uint8_t reserved; /* 0 */
	uint16_t x_hotspot;
	uint16_t y_hotspot;
	uint32_t size;
	uint32_t offset; /* position of the image in file */
} icondirentry;

typedef struct {
	uint16_t reserved; /* 0 */
	uint16_t type;	/* 1 = icon, 2 = cursor */
	uint16_t count;
} icondir;

void die(const char *msg, ...)
{
	va_list argp;
	
	va_start(argp, msg);
	vfprintf(stderr, msg, argp);
	if (errno)
		fprintf(stderr, ": %s", strerror(errno));
	putc('\n', stderr);
	va_end(argp);
	exit(EXIT_FAILURE);
}

uint16_t get_axis(const char *s, char axis)
{
	short ret;
	char *tail;
	
	ret = strtol(s, &tail, 0);
	if (ret < 0 || ret > 31 || s == tail)
		die("invalid value for %c: %s", axis, s);
	return ret;
}

void check_if_png(const char *name, FILE *f)
{
	char buf[PNG_BYTES] = "";

	rewind(f);
	fread(buf, sizeof(*buf), PNG_BYTES, f);
	if (png_sig_cmp((png_const_bytep)buf, 0, PNG_BYTES) != 0)
		die("%s: not a PNG file", name);
	rewind(f);
}

uint32_t get_file_size(FILE *f)
{
	uint32_t ret;
	
	rewind(f);
	fseeko(f, 0, SEEK_END);
	ret = ftello(f);
	rewind(f);
	return ret;
}

int main(int argc, char **argv)
{
	int c;
	char buf[BUFSIZ];
	size_t read;
	uint16_t x, y;
	FILE *fdest, *fsrc;
	char *dest, *src;
	icondir ib;
	icondirentry ie;
	png_image pmb;

	x = y = 0;
	while ((c = getopt(argc, argv, "x:y:")) != -1) {
		switch (c) {
		case 'x':
			x = get_axis(optarg, c);
			break;
		case 'y':
			y = get_axis(optarg, c);
			break;
		default:
			exit(EXIT_FAILURE);
		}
	}
	memset(&ib, 0, sizeof(ib));
	memset(&ie, 0, sizeof(ie));
	memset(&pmb, 0, sizeof(pmb));
	pmb.version = PNG_IMAGE_VERSION;
	pmb.format = PNG_FORMAT_RGBA;
	ib.reserved = 0;
	ib.type = 2;
	ib.count = 1;
	if (argc - optind < 2)
		die("need source and dest files");
	src = argv[optind];
	dest = argv[optind + 1];
	if (!(fsrc = fopen(src, "r")))
		die("fopen: %s", src);
	check_if_png(src, fsrc);
	if (png_image_begin_read_from_stdio(&pmb, fsrc) == 0)
		die("png_image_begin_read_from_stdio: %s", pmb.message);
	if (!(fdest = fopen(dest, "w")))
		die("fopen: %s", dest);
	ie.width = pmb.width;
	ie.height = pmb.height;
	ie.x_hotspot = x;
	ie.y_hotspot = y;
	ie.size = get_file_size(fsrc);
	ie.offset = sizeof(ib) + sizeof(ie);
	fwrite(&ib, sizeof(ib), 1, fdest);
	fwrite(&ie, sizeof(ie), 1, fdest);
	while ((read = fread(buf, sizeof(*buf), sizeof(buf), fsrc)))
		fwrite(buf, sizeof(*buf), read, fdest);
	fclose(fdest);
	return EXIT_SUCCESS;
}
