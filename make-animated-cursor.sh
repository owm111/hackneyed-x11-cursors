#!/usr/bin/env bash
#
# Copyright (C) Richard Ferreira
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR THE COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Except as contained in this notice, the name(s) of the above copyright
# holders shall not be used in advertising or otherwise to promote the sale,
# use or other dealings in this Software without prior written authorization.

die()
{
	echo $@ >&2
	exit 1
}

while [ "$1" ]; do
	case "$1" in
	size=*)
		size=${1#*=}
		shift ;;
	src=*)
		src=${1#*=}
		shift ;;
	target=*)
		target=${1#*=}
		shift ;;
	frames=*)
		frames=${1#*=}
		shift ;;
	default_frametime=*)
		default_frametime=${1#*=}
		shift ;;
	frame_*_time=*)
		var=${1%=*}
		eval $var=${1#*=}
		shift ;;
	*)
		die "invalid parameter: $1"
	esac
done

: ${default_frametime:=30}
: ${size:?need a cursor size to work}
: ${src:?no source svg specified}
: ${target:?missing target}
: ${frames:?missing frame count}
dpi=$(( (96 * size)/24 ))
: ${dpi:?invalid size $size}
center=$(( (size - 1) / 2 ))
rm -f ${target}.${size}.in
for ((i = 1; i <= frames; i++)); do
	output="${target}-${i}.${size}.png"
	echo "$target ($size): $output"
	inkscape --without-gui -i "$target-$i" -d $dpi -f $src -e $output >/dev/null || die
	eval frametime=\$frame_${i}_time
	: ${frametime:=$default_frametime}
	echo "$size $center $center $output ${frametime}" >> ${target}.${size}.in || die
done