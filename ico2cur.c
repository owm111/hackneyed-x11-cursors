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
#include <math.h>

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

struct hotspot {
	uint8_t width;
	uint8_t height;
	uint16_t x_hotspot;
	uint16_t y_hotspot;
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

struct hotspot *const find_hotspot(uint8_t w, uint8_t h, struct hotspot *const hb, int len)
{
	int i;

	for (i = 0; i < len; i++) {
		if (hb[i].width == w && hb[i].height == h)
			return &hb[i];
	}
	return NULL;
}

void ico2cur(const char *src, const char *dest, uint16_t x, uint16_t y, struct hotspot *const hb, size_t hblen)
{
	FILE *fdest;
	FILE *fsrc;
	uint16_t zero_w, zero_h;
	size_t i;
	size_t w;
	off_t start;
	char buf[BUFSIZ];
	struct iconfile *fb;
	const struct hotspot *hb_siz;

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
		if ((hb_siz = find_hotspot(fb->ie[i].width, fb->ie[i].height, hb, hblen))) {
			fb->ie[i].x_hotspot = hb_siz->x_hotspot;
			fb->ie[i].y_hotspot = hb_siz->y_hotspot;
		} else {
			fb->ie[i].x_hotspot = round((double)(fb->ie[i].width * x) / zero_w);
			fb->ie[i].y_hotspot = round((double)(fb->ie[i].width * y) / zero_h);
		}
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
	iffree(&fb);
}

uint16_t get_axis(const char *s, char axis)
{
	uint16_t ret;
	char *tail;
	
	ret = strtol(s, &tail, 0);
	if (s == tail)
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

struct hotspot *hotspot_from_string(const char *src, struct hotspot *dest)
{
	char *width, *height, *hotspot_x, *hotspot_y;
	char *tail;

	if (*src != '@')
		return NULL;
	width = strdup(src + 1);
	if (!(height = strchr(width, 'x')))
		goto out;
	*height = 0;
	height++;
	if (!(hotspot_x = strchr(height, '=')))
		goto out;
	*hotspot_x = 0;
	hotspot_x++;
	if (!(hotspot_y = strchr(hotspot_x, ',')))
		goto out;
	*hotspot_y = 0;
	hotspot_y++;
	dest->width = strtol(width, &tail, 10);
	if (width == tail)
		die("invalid width: %s", width);
	dest->height = strtol(height, &tail, 10);
	if (height == tail)
		die("invalid height: %s", height);
	dest->x_hotspot = strtol(hotspot_x, &tail, 10);
	if (hotspot_x == tail)
		die("invalid x axis: %s", hotspot_x);
	dest->y_hotspot = strtol(hotspot_y, &tail, 10);
	if (hotspot_y == tail)
		die("invalid y axis: %s", hotspot_x);
out:
	free(width);
	return NULL;
}

void hotspots_from_file(const char *src, const char *name, struct hotspot **hb, size_t *len)
{
	FILE *f = fopen(src, "r");
	char buf[BUFSIZ] = "";
	char *hotspots;
	struct hotspot new_hb;
	void *new;
	size_t start_len = *len;

	if (!f)
		die("fopen: %s", src);
	while (fgets(buf, sizeof(buf), f)) {
		if (*buf == '#' || *buf == ';')
			continue;
		strbtrim(buf, "\n\t ");
		if (!(hotspots = strchr(buf, '\t')))
			continue;
		*hotspots = 0;
		hotspots++;
		strbtrim(hotspots, "\n\t ");
		if (!hotspot_from_string(hotspots, &new_hb))
			continue;
		++(*len);
		if (!(new = realloc(*hb, sizeof(**hb) * *len)))
			die("%s: realloc error", __func__);
		*hb = new;
		(*hb)[*len - 1] = new_hb;
	}
	fclose(f);
	if (*len == start_len)
		die("no hotspots for %s in %s", name, src);
}

struct hotspot *hotspots_from_cmdline(int argc, char *const *argv)
{
	struct hotspot *ret = malloc(sizeof(*ret) * argc);
	int i;
	int processed = 0;

	for (i = 0; i < argc; i++)
		if (hotspot_from_string(argv[i], &ret[i]))
			processed++;
	if (processed == 0) {
		free(ret);
		ret = NULL;
	}
	return ret;
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
	struct hotspot *hb = NULL;
	size_t hblen;
	
	x = y = 0;
	while ((c = getopt(argc, argv, "x:y:hp:I:i:")) != -1) {
		switch (c) {
		case 'x':
			x = get_axis(optarg, c);
			break;
		case 'y':
			y = get_axis(optarg, c);
			break;
		case 'h':
			die("usage: ico2cur -i <infile.ico> [-x x_axis -y y_axis|-p hotspotsrc|@W1xH1=x1,y1 @W2xH2=x2,y2 ... @WnxHn=xn,yn]");
			break;
		case 'p':
			hotspotsrc = strdup(optarg);
			break;
		case 'I':
			get_ico_info(optarg);
			break;
		case 'i':
			src = strdup(optarg);
			break;
		default:
			exit(EXIT_FAILURE);
		}
	}
	hblen = 0;
	if (argc > optind) {
		hblen = argc - optind;
		if (!(hb = hotspots_from_cmdline(hblen, &argv[optind])))
			hblen = 0;
	} else {
		if (!src && !hotspotsrc)
			die("no input file specified and no hotspots given in command line");
	}
	if (hotspotsrc) {
		strncpy(buf, src, sizeof(buf));
		p = basename(buf);
		name = extsub(p, NULL);
		hotspots_from_file(hotspotsrc, name, &hb, &hblen);
		free(name);
		free(hotspotsrc);
	}
	dest = extsub(src, ".cur");
	ico2cur(src, dest, x, y, hb, hblen);
	free(hb);
	free(dest);
	free(src);
	return 0;
}
