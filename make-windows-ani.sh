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
	hotspot_src=*)
		hotspot_src=${1#*=}
		shift ;;
	output_ani=*)
		output_ani=${1#*=}
		shift ;;
	left=*)
		left=${1#*=}
		shift ;;
	*)
		die "invalid parameter: $1"
	esac
done

: ${default_frametime:=1}
: ${src:?no source svg specified}
: ${target:?missing target}
: ${frames:?missing frame count}
: ${hotspot_x:=15}
: ${hotspot_y:=15}
: ${output_ani:?no output file specified}
dpi=96
size=24
variant=${target#*.}
target=${target%.*}
: ${hotspot_src:=theme/${size}/${target}.in}
set -- $hotspot_x $hotspot_y
[ -e $hotspot_src ] && set -- $(cut -d' ' -f2,3 $hotspot_src)
if [ "$variant" = "large" ]; then
	x=$(( (32 * $1) / (24 - 1) ))
	y=$(( (32 * $2) / (24 - 1) ))
	dpi=$(( (96 * 32) / 24 ))
	size=32
	set -- $x $y
fi
for ((i = 1; i <= frames; i++)); do
	[ "$left" = 1 ] && output="${target}-${i}.${size}.left.png" || output="${target}-${i}.${size}.png"
	output_ico="${output%*.png}.ico"
	output_cur="${output%*.png}.cur"
	inkscape --without-gui -i "$target-$i" -d $dpi -f $src -e $output >/dev/null || die
	convert -background none -extent 32x32 $output $output_ico || die
	./ico2cur -x $1 -y $2 $output_ico || die
	eval frametime=\$frame_${i}_time
	[ "$frametime" ] && output_cur="$output_cur=$frametime"
	cmdline="$cmdline $output_cur"
done
./animaker -o ${output_ani} -t $default_frametime $cmdline
