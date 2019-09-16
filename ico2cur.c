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
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <getopt.h>
#include <stdarg.h>
#include <errno.h>

#define HEADERLEN	13
#define ICONMAX		1024

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
	uint16_t count; /* icondirentry[count] entries */
} icondir;

struct iconfile {
	icondir ib;
	icondirentry *ie;
};

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

void iffree(struct iconfile **fb)
{
	free((*fb)->ie);
	free(*fb);
}

struct iconfile *get_ico_headers(const char *src)
{
	FILE *f = fopen(src, "r");
	size_t i;
	struct iconfile *ret;

	if (!f)
		die("fopen: %s", src);
	ret = malloc(sizeof(*ret));
	memset(ret, 0, sizeof(*ret));
	fread(&ret->ib, sizeof(ret->ib), 1, f);
	if (ret->ib.reserved != 0 || (ret->ib.type != 1 && ret->ib.type != 2) || ret->ib.count == 0 || ret->ib.count > ICONMAX)
		die("%s: not an ICO/CUR file or corrupted", src);
	ret->ie = malloc(sizeof(*ret->ie) * ret->ib.count);
	for (i = 0; i < ret->ib.count; i++) {
		if (fread(&ret->ie[i], sizeof(*ret->ie), 1, f) < sizeof(*ret->ie) && feof(f))
			die("%s: unexpected end of file", src);
		if (ferror(f))
			die("%s: read error", src);
		if (ret->ie[i].reserved != 0)
			die("%s: invalid icondirentry", src);
	}
	fclose(f);
	return ret;
}

void get_ico_info(const char *name)
{
	size_t i;
	const char *filetype = "icon";
	const char *field_5 = "planes";
	const char *field_6 = "bpp";
	struct iconfile *fb;

	fb = get_ico_headers(name);
	if (fb->ib.type == 2) {
		filetype = "cursor";
		field_5 = "x_hotspot";
		field_6 = "y_hotspot";
	}
	printf("%s\n", name);
	printf("filetype: %s (%u)\n", filetype, fb->ib.type);
	printf("icondirentry count: %u\n", fb->ib.count);
	printf("-------------------------\n");
	for (i = 0; i < fb->ib.count; i++) {
		printf("[%lu] dimensions: %ux%u\n", i, fb->ie[i].width, fb->ie[i].height);
		printf("[%lu] colors: %u\n", i, fb->ie[i].colors);
		printf("[%lu] %s: %u\n", i, field_5, fb->ie[i].x_hotspot);
		printf("[%lu] %s: %u\n", i, field_6, fb->ie[i].y_hotspot);
		printf("[%lu] image size: %u\n", i, fb->ie[i].size);
		printf("[%lu] image offset: %u\n", i, fb->ie[i].offset);
		if (fb->ib.count - i > 1)
			printf("-------------------------\n");
	}
	iffree(&fb);
	exit(EXIT_SUCCESS);
}

void ico2cur(const char *src, const char *dest, uint16_t x, uint16_t y)
{
	FILE *fdest;
	FILE *fsrc;
	uint16_t zero_w, zero_h;
	size_t i;
	size_t w;
	off_t start;
	char buf[BUFSIZ];
	struct iconfile *fb;

	fb = get_ico_headers(src);
	fb->ib.type = 2;
	zero_w = fb->ie[0].width;
	zero_h = fb->ie[0].height;
	for (i = 1; i < fb->ib.count; i++) {
		if (fb->ie[i].width < zero_w)
			zero_w = fb->ie[i].width;
		if (fb->ie[i].height < zero_h)
			zero_h = fb->ie[i].height;
	}
	for (i = 0; i < fb->ib.count; i++) {
		fb->ie[i].x_hotspot = (fb->ie[i].width * x) / zero_w;
		fb->ie[i].y_hotspot = (fb->ie[i].width * y) / zero_h;
		printf("[%lu]: %ux%u (%d,%d)\n", i, fb->ie[i].width, fb->ie[i].height,
			fb->ie[i].x_hotspot, fb->ie[i].y_hotspot);
	}
	if (!(fdest = fopen(dest, "w")))
		die("fopen: %s", dest);
	if (!(fsrc = fopen(src, "r")))
		die("fopen: %s", src);
	fwrite(&fb->ib, sizeof(fb->ib), 1, fdest);
	fwrite(fb->ie, sizeof(*fb->ie), fb->ib.count, fdest);
	start = ftello(fdest);
	fseeko(fsrc, start, SEEK_SET);
	while ((w = fread(buf, sizeof(*buf), sizeof(buf), fsrc)))
		fwrite(buf, sizeof(*buf), w, fdest);
	fclose(fsrc);
	fclose(fdest);
	printf("%s -> %s\n", src, dest);
}

uint16_t get_axis(const char *s, char axis)
{
	int16_t ret;
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
	int c;
	uint16_t x, y;
	char buf[BUFSIZ] = "";
	char *src = NULL;
	char *dest = NULL;
	char *p;
	char *hotspotsrc = NULL, *name = NULL;
	
	x = y = 0;
	while ((c = getopt(argc, argv, "x:y:hp:i:")) != -1) {
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
		case 'i':
			get_ico_info(optarg);
			break;
		default:
			exit(EXIT_FAILURE);
		}
	}
	if (argc > optind)
		src = argv[optind];
	else
		die("no filename specified");
	if (hotspotsrc) {
		strncpy(buf, src, sizeof(buf));
		p = basename(buf);
		name = extsub(p, NULL);
		get_hotspot(hotspotsrc, name, &x, &y);
		free(name);
		free(hotspotsrc);
	}
	dest = extsub(src, ".cur");
	ico2cur(src, dest, x, y);
	return 0;
}
