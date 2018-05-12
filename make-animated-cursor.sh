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
	sizes=*)
		sizes=${1#*=}
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
	default_frame_delay=*)
		default_frame_delay=${1#*=}
		shift ;;
	frame_*_delay=*)
		var=${1%=*}
		eval $var=${1#*=}
		shift ;;
	*)
		die "invalid parameter: $1"
	esac
done

: ${default_frame_delay:=30}
: ${sizes:?need a list of cursor sizes to work}
: ${src:?no source svg specified}
: ${target:?missing target}
: ${frames:?missing frame count}
for s in $sizes; do
	dpi=$(( (90 * s)/32 ))
	: ${dpi:?invalid size $s}
	center=$(( (s / 2) - 1 ))
	rm -f ${target}.${s}.in
	for ((i = 1; i <= frames; i++)); do
		output="${target}-${i}.${s}.png"
		echo "$target: $output"
		inkscape --without-gui -i "$target-$i" -d $dpi -f $src -e $output >/dev/null || die
		eval frame_delay=\$frame_${i}_delay
		echo "$s $center $center $output ${frame_delay:=$default_frame_delay}" >> ${target}.${s}.in || die
	done
done
