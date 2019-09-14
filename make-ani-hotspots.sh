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
: ${target:?missing target}
: ${frames:?missing frame count}
center=$(( (size - 1) / 2 ))

variant=${target#*.}
hotspot_src=theme/${size}/${target}.in
hotspot_dest=${target}.${size}.in
[ "$variant" = "$target" ] && unset variant
if [ "$variant" ]; then
	target=${target%.*}
	hotspot_src=theme/${size}/${target}_${variant}.in
	hotspot_dest=${target}_${variant}.${size}.in
fi

hotspot="$size $center $center"
[ -e $hotspot_src ] && hotspot=$(cut -d' ' -f1-3 $hotspot_src)
rm -f $hotspot_dest
for ((i = 1; i <= frames; i++)); do
	[ "$variant" ] && output="${target}-${i}.${size}.${variant}.png" || output="${target}-${i}.${size}.png"
	echo "make-ani-hotspots.sh: $target ($size): $output"
	eval frametime=\$frame_${i}_time
	: ${frametime:=$default_frametime}
	echo "$hotspot $output ${frametime}" >> $hotspot_dest || die
done