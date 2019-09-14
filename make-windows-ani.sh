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

SIZES='24 48 64'

die()
{
	echo $@ >&2
	exit 1
}

make_source_list()
{
	local custom_hotspot

	for s in $SIZES; do
		eval [ "\$hotspot_${s}" ] && eval custom_hotspot="=\$hotspot_${s}"
		[ "$variant" ] && source_pngs="$source_pngs $@.$s.${variant}.png${custom_hotspot}" ||\
			source_pngs="$source_pngs $@.$s.png${custom_hotspot}"
	done
}

while [ "$1" ]; do
	case "$1" in
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
	hotspot_*=*)
		var=${1%=*}
		eval $var=${1#*=}
		shift ;;
	output_ani=*)
		output_ani=${1#*=}
		shift ;;
	*)
		die "invalid parameter: $1"
	esac
done

: ${default_frametime:=1}
: ${target:?missing target}
: ${frames:?missing frame count}
: ${output_ani:?no output file specified}
: ${hotspot_src:=theme/24/${target}.in}
variant=${target#*.}
[ "$variant" = "$target" ] && unset variant
if [ "$variant" ]; then
	target=${target%.*}
	hotspot_src=theme/24/${target}_${variant}.in
fi
: ${hotspot_x:=0}
: ${hotspot_y:=0}
if [ -e $hotspot_src ]; then
	set -- $(cut -d' ' -f2,3 $hotspot_src)
	hotspot_x=$1
	hotspot_y=$2
fi
for ((i = 1; i <= frames; i++)); do
	make_source_list "${target}-${i}"
	output_cur="${target}-${i}.cur"
	./png2cur -x $hotspot_x -y $hotspot_y -o $output_cur $source_pngs || die
	eval frametime=\$frame_${i}_time
	[ "$frametime" ] && output_cur="$output_cur=$frametime"
	cmdline="$cmdline $output_cur"
	unset source_pngs
done
./animaker -o ${output_ani} -t $default_frametime $cmdline
