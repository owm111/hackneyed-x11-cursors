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
 
 /* png2cur.c: convert one or more PNG files to a Windows cursor (.cur) file
  * requires:	libpng >= 1.6.36
  * 		ImageMagick >= 6.9.10
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
#include <libgen.h>
#include <png.h>
#include <sys/stat.h>
#include <math.h>
#include <wand/magick_wand.h>

#define ICONMAX			1024
#define PNG_BYTES		8
#define TEMPFNAME_PREFIX	".png2cur"

typedef enum {
	GET_BASENAME,
	GET_DIRNAME
} component_t;

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

struct fileinfo {
	char *fname;
	icondirentry ie;
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

uint16_t get_axis(const char *s, char axis)
{
	short ret;
	char *tail;
	
	ret = strtol(s, &tail, 0);
	if (ret < 0 || ret > 31 || s == tail)
		die("invalid value for %c: %s", axis, s);
	return ret;
}

void check_if_png(const char *name)
{
	char buf[PNG_BYTES] = "";
	FILE *f = fopen(name, "r");

	if (!f)
		die("%s: fopen: %s", __func__, name);
	fread(buf, sizeof(*buf), PNG_BYTES, f);
	if (png_sig_cmp((png_const_bytep)buf, 0, PNG_BYTES) != 0)
		die("%s: not a PNG file", name);
	fclose(f);
}

char *get_file_component(component_t what, const char *filename)
{
	char *buf = strdup(filename);
	char *p, *ret, *fname;
	char *(*component_func)(char *);

	switch (what) {
	case GET_BASENAME:
		component_func = basename;
		break;
	case GET_DIRNAME:
		component_func = dirname;
	}
	if (!buf)
		die("%s: malloc error", __func__);
	p = buf;
	fname = component_func(buf);
	if (!(ret = strdup(fname)))
		die("%s: malloc error", __func__);
	free(p);
	return ret;
}

long get_pathmax(const char *dirpath)
{
	long pathmax;

	if ((pathmax = pathconf(dirpath, _PC_PATH_MAX)) < 0) {
		if (errno)
			die("%s: pathconf: %s", __func__, dirpath);
		pathmax = _POSIX_PATH_MAX;
	}
	return pathmax;
}

char *png_add_extent(const char *src, uint8_t *old_width, uint8_t *old_height)
{
	MagickWand *mb = NULL;
	PixelWand *pb;
	int width, height;
	long pathmax = get_pathmax(src);
	char *basefname, *dirfname;
	char *extfname, *outfname;

	if (!(extfname = malloc(pathmax)))
		die("%s: malloc error", __func__);
	if (!(outfname = malloc(pathmax)))
		die("%s: malloc error", __func__);
	basefname = get_file_component(GET_BASENAME, src);
	dirfname = get_file_component(GET_DIRNAME, src);
	snprintf(extfname, pathmax - 1, "%s/%s-%s", dirfname, TEMPFNAME_PREFIX, basefname);
	snprintf(outfname, pathmax - 1, "png32:%s/%s-%s", dirfname, TEMPFNAME_PREFIX, basefname);
	MagickWandGenesis();
	mb = NewMagickWand();
	pb = NewPixelWand();
	PixelSetColor(pb, "none");
	MagickReadImage(mb, src);
	width = MagickGetImageWidth(mb);
	height = MagickGetImageHeight(mb);
	if (width >= 32 && height >= 32) {
		free(extfname);
		extfname = NULL;
		goto noop;
	}
	*old_width = width;
	*old_height = height;
	MagickSetImageBackgroundColor(mb, pb);
	MagickExtentImage(mb, 32, 32, 0, 0);
	if (MagickWriteImage(mb, outfname) == MagickFalse)
		die("%s: MagickWriteImage failed", src);
noop:
	mb = DestroyMagickWand(mb);
	pb = DestroyPixelWand(pb);
	MagickWandTerminus();
	free(basefname);
	free(dirfname);
	free(outfname);
	return extfname;
}

int get_hotspots(const char *fname, struct fileinfo *fb)
{
	char *hotspot_x, *hotspot_y;
	char *tail;

	memset(fb, 0, sizeof(*fb));
	fb->fname = strdup(fname);
	if (!(hotspot_x = strrchr(fb->fname, '=')))
		return 0;
	*hotspot_x = 0;
	hotspot_x++;
	if (!(hotspot_y = strchr(hotspot_x, ',')))
		die("invalid hotspot coordinates: %s", hotspot_x);
	*hotspot_y = 0;
	hotspot_y++;
	if (!*hotspot_y)
		die("empty y pixel");
	fb->ie.x_hotspot = strtol(hotspot_x, &tail, 10);
	if (hotspot_x == tail)
		die("invalid x hotspot: %s", hotspot_x);
	fb->ie.y_hotspot = strtol(hotspot_y, &tail, 10);
	if (hotspot_y == tail)
		die("invalid y hotspot: %s", hotspot_y);
	return 1;
}

/* file.png=4,4 */
struct fileinfo *get_fileinfo(int argc, char **argv, uint16_t base_x, uint16_t base_y)
{
	struct fileinfo *ret = malloc(argc * sizeof(*ret));
	struct stat sb;
	char *extfname;
	png_image pmb;
	uint8_t zero_w, zero_h;
	int has_hotspot = 0;
	int i;

	if (!ret)
		die("malloc error");
	zero_w = zero_h = 0;
	for (i = 0; i < argc; i++) {
		has_hotspot = get_hotspots(argv[i], &ret[i]);
		check_if_png(ret[i].fname);
		pmb.version = PNG_IMAGE_VERSION;
		pmb.format = PNG_FORMAT_RGBA;
		if ((extfname = png_add_extent(ret[i].fname, &zero_w, &zero_h))) {
			free(ret[i].fname);
			ret[i].fname = extfname;
		}
		if (png_image_begin_read_from_file(&pmb, ret[i].fname) == 0)
			die("libpng error: %s", pmb.message);
		if (stat(ret[i].fname, &sb) < 0)
			die("stat: %s", ret[i].fname);
		ret[i].ie.size = sb.st_size;
		ret[i].ie.width = pmb.width;
		ret[i].ie.height = pmb.height;
		if (!has_hotspot) {
			if (zero_w && zero_h && !extfname) {
				ret[i].ie.x_hotspot = round((double)(ret[i].ie.width * ret[0].ie.x_hotspot) / zero_w);
				ret[i].ie.y_hotspot = round((double)(ret[i].ie.height * ret[0].ie.y_hotspot) / zero_h);
			} else {
				ret[i].ie.x_hotspot = base_x;
				ret[i].ie.y_hotspot = base_y;
			}
		}
		memset(&pmb, 0, sizeof(pmb));
	}
	return ret;
}

void fbfree(struct fileinfo **fb, size_t len)
{
	int i;

	for (i = 0; i < len; i++)
		free((*fb)[i].fname);
	free(*fb);
}

void write_pngs(struct fileinfo *fb, size_t count, FILE *dest)
{
	char buf[BUFSIZ];
	FILE *src;
	int i;
	size_t read;

	for (i = 0; i < count; i++) {
		memset(buf, 0, sizeof(buf));
		if (!(src = fopen(fb[i].fname, "r")))
			die("fopen: %s", fb[i].fname);
		while ((read = fread(buf, sizeof(*buf), sizeof(buf), src)))
			fwrite(buf, sizeof(*buf), read, dest);
		fclose(src);
		if (!strncmp(fb[i].fname, TEMPFNAME_PREFIX, strlen(TEMPFNAME_PREFIX))) /* temporary file */
			if (remove(fb[i].fname) < 0)
				fprintf(stderr, "%s: removing %s: %s", __func__, fb[i].fname, strerror(errno));
	}
}

int main(int argc, char **argv)
{
	int c;
	uint16_t x, y;
	struct fileinfo *fb;
	FILE *fdest;
	char *dest = NULL;
	size_t i;
	icondir ib;

	x = y = 0;
	while ((c = getopt(argc, argv, "x:y:o:")) != -1) {
		switch (c) {
		case 'x':
			x = get_axis(optarg, c);
			break;
		case 'y':
			y = get_axis(optarg, c);
			break;
		case 'o':
			dest = strdup(optarg);
			break;
		default:
			exit(EXIT_FAILURE);
		}
	}
	if (!dest)
		die("need a destination file");
	ib.reserved = 0;
	ib.type = 2;
	if (argc - optind == 0)
		die("specify at least one source PNG");
	ib.count = argc - optind;
	fb = get_fileinfo(ib.count, &argv[optind], x, y);
	if (!(fdest = fopen(dest, "w")))
		die("fopen: %s", dest);
	fwrite(&ib, sizeof(ib), 1, fdest);
	fb[0].ie.offset = sizeof(ib) + sizeof(fb[0].ie) * ib.count;
	for (i = 1; i < ib.count; i++)
		fb[i].ie.offset = fb[i - 1].ie.offset + fb[i - 1].ie.size;
	for (i = 0; i < ib.count; i++) {
		printf("%s[%lu]: %dx%d, hotspot %d,%d\n", dest, i, fb[i].ie.width,
			fb[i].ie.height, fb[i].ie.x_hotspot, fb[i].ie.y_hotspot);
		fwrite(&fb[i].ie, sizeof(fb[i].ie), 1, fdest);
	}
	write_pngs(fb, ib.count, fdest);
	fclose(fdest);
	fbfree(&fb, ib.count);
	return EXIT_SUCCESS;
}
