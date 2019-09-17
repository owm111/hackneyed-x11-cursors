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

 /* animaker.c: create a Windows ANI out of several CUR/ICO files */

 #if defined __GNUC__ && !defined _GNU_SOURCE
# define _GNU_SOURCE
#endif

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

typedef struct {
	char id[4];
	uint32_t size;
} chunk_t;

/* not sure if I should store metadata (author, copyright, title etc.)
 * must be done right after ACON (LIST + INFO) */
struct anifile {
	chunk_t riff_header;
	char acon[4];
	chunk_t anih; /* id = "anih", size = 36 */
	uint32_t header_size; /* always 36 */
	uint32_t frames;
	uint32_t steps; /* = frames */
	uint32_t width, height; /* always 0 */
	uint32_t bits; /* 0 */
	uint32_t planes; /* 0 */
	uint32_t display_rate; /* in jiffies, i.e., 1/60s (16.66ms) */
	/* flags:
	 * bits 31..32: unused (always 0)
	 * bit 1: true (file contains sequence data)
	 * bit 0:
	 * 	- true (frames are ICO/cursor)
	 * 	- false (frames are raw data)
	 * for my purposes, setting bit 0 to 1 is enough */
	uint32_t flags;
	/* write rate, fram and follow with the CUR chunks afterwards. keep track of the file size */
};

struct frameinfo {
	char *fname;
	uint32_t fsize;
	uint32_t jiffies;
};

char *u32tostr(uint32_t dword)
{
	static char ret[4];
	int i;

	for (i = 0; i < 4; i++)
		ret[i] = *((uint8_t *)(&dword) + i);
	return ret;
}

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

struct frameinfo *get_frameinfo(int argc, char **argv, uint32_t default_rate)
{
	struct frameinfo *ret = malloc(argc * sizeof(*ret));
	char *ftime;
	char *tail;
	struct stat sb;
	int i;

	if (!ret)
		return NULL;
	for (i = 0; i < argc; i++) {
		ret[i].fname = strdup(argv[i]);
		ret[i].jiffies = default_rate;
		if ((ftime = strchr(ret[i].fname, '='))) {
			*ftime = 0;
			ftime++;
			ret[i].jiffies = strtol(ftime, &tail, 10);
			if (ftime == tail)
				die("%s: invalid frametime for \"%s\": %s", __func__, ret[i].fname, ftime);
		}
		if (stat(ret[i].fname, &sb) < 0)
			die("%s: stat", __func__);
		ret[i].fsize = sb.st_size;
	}
	return ret;
}

/* the rate chunk is a uint32_t array of jiffies, one for each frame
* chunk size is 4 bytes (32 bits) * step count */
size_t write_rate(FILE *f, struct frameinfo *fb, int len)
{
	chunk_t rate;
	int i;

	memcpy(rate.id, "rate", 4);
	rate.size = len * sizeof(fb[i].jiffies);
	fwrite(&rate, sizeof(rate), 1, f);
	for (i = 0; i < len; i++)
		fwrite(&fb[i].jiffies, sizeof(fb[i].jiffies), 1, f);
	return sizeof(rate) + rate.size;
}

size_t write_fram(FILE *f, struct frameinfo *fb, int len)
{
	chunk_t icon, list;
	FILE *src;
	char buf[BUFSIZ];
	int i;
	size_t nread, padding;

	memcpy(list.id, "LIST", 4);
	/* "fram" == 4 */
	list.size = 4 + sizeof(icon) * len;
	for (i = 0; i < len; i++) {
		/* odd chunks need padding */
		if (fb[i].fsize % 2 != 0)
			padding++;
		list.size += fb[i].fsize;
	}
	/* LIST size must include padding */
	list.size += padding;
	fwrite(&list, sizeof(list), 1, f);
	fwrite("fram", 4, 1, f);
	memcpy(icon.id, "icon", 4);
	for (i = 0; i < len; i++) {
		if (!(src = fopen(fb[i].fname, "r")))
			die("%s: fopen: %s", __func__, fb[i].fname);
		icon.size = fb[i].fsize;
		fwrite(&icon, sizeof(icon), 1, f);
		while ((nread = fread(buf, sizeof(*buf), sizeof(buf), src)))
			fwrite(buf, sizeof(*buf), nread, f);
		if (icon.size % 2 != 0)
			fputc(0, f);
		fclose(src);
	}
	return sizeof(list) + list.size;
}

void fmfree(struct frameinfo **fb, int len)
{
	int i;

	for (i = 0; i < len; i++)
		free((*fb)[i].fname);
	free(*fb);
}

int main(int argc, char **argv)
{
	struct anifile af;
	FILE *f;
	int c;
	char *outfile = NULL;
	char *tail;
	struct frameinfo *fb;

	memset(&af, 0, sizeof(af));
	memcpy(af.riff_header.id, "RIFF", 4);
	memcpy(af.acon, "ACON", 4);
	memcpy(af.anih.id, "anih", 4);
	af.header_size = 36;
	af.anih.size = 36;
	af.display_rate = 1;
	af.flags = 1;
	while ((c = getopt(argc, argv, "o:t:")) != -1) {
		switch (c) {
		case 'o':
			outfile = strdup(optarg);
			break;
		case 't':
			af.display_rate = strtol(optarg, &tail, 10);
			if (optarg == tail)
				die("invalid value for -t: %s", optarg);
			break;
		default:
			exit(EXIT_FAILURE);
		}
	}
	if (argc == optind)
		die("no input files specified");
	af.frames = argc - optind;
	af.steps = af.frames;
	if (!outfile)
		die("no output file specified");
	if (!(fb = get_frameinfo(af.frames, &argv[optind], af.display_rate)))
		die("error getting frameinfo");
	if (!(f = fopen(outfile, "w")))
		die("fopen: %s", outfile);
	fseek(f, sizeof(af), SEEK_SET);
	af.riff_header.size = sizeof(af) + write_rate(f, fb, af.frames) + write_fram(f, fb, af.frames) - 8;
	rewind(f);
	fwrite(&af, sizeof(af), 1, f);
	printf("%s: %u bytes, %u frames\n", outfile, af.riff_header.size, af.frames);
	fmfree(&fb, af.frames);
	free(outfile);
	fclose(f);
	return 0;
}
