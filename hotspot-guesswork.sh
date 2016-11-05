#!/bin/bash

# Copyright (C) Ludvig Hummel, Richard Ferreira
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

. sh-functions
LC_NUMERIC=C

while [ "$1" ]; do
	case "$1" in
	sizes=*)
		sizes=${1#*=}
		shift
		;;
	replace=*)
		replace=${1#*=}
		shift
		;;
	base_size_line=*)
		base_size_line=${1#*=}
		shift
		;;
	dry_run=*)
		dry_run=${1#*=}
		shift
		;;
	*)
		c=$1
		shift
		;;
	esac
done

: ${c:?no file specified}
target=${c%.*}
orientation=${c#*.}
c=$target
: ${target:?undefined}
: ${sizes:?no size specified}
: ${replace:=1}
: ${dry_run:=0}

filename="$(basename $target).png"
target="${c}.in"
if [ "$orientation" = "left" ]; then
	target="${c}.in_left"
	c="${c}.left"
	filename="${filename/.png/_left.png}"
fi
: ${filename:?undefined}
nominal_size=$(cut -d' ' -f1 <<< $base_size_line)
: ${nominal_size:?undefined}
dynaspot ${nominal_size}/${filename}
base_hotspot_x=$(cut -d' ' -f2 <<< $base_size_line)
: ${base_hotspot_x:undefined}
base_hotspot_y=$(cut -d' ' -f3 <<< $base_size_line)
: ${base_hotspot_y:undefined}

base_size_x=$size_x
base_size_y=$size_y
echo "$nominal_size ${base_hotspot_x} ${base_hotspot_y} $filename"

for s in $sizes; do
	config_file=config/${s}/${target}
	if [ -e $config_file -a "$replace" = "0" ]; then
		echo "$config_file: skipping $s" >&2
		continue
	fi
	png="${s}/${filename}"
	if [ ! -e $png ]; then
		./make-pngs.sh sizes=${s} target=$c || exit 1
	fi
	dynaspot $png
	echo "$png: ${size_x}x${size_y}"
	hotspot_x=$(calc "$base_hotspot_x * ($size_x / $base_size_x)")
	hotspot_y=$(calc "$base_hotspot_y * ($size_y / $base_size_y)")

	output="${s} ${hotspot_x} ${hotspot_y} ${s}/$(basename $filename)"
	echo "$config_file: $output"
	[ "$dry_run" = "1" ] || echo "${output}" > $config_file
done
