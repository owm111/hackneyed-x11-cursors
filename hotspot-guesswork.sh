#!/bin/bash

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

LC_NUMERIC=C

calc()
{
	printf "%.0f" $(bc <<< "scale=3; $@")
}

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
		target=$1
		shift
		;;
	esac
done

orientation=${target#*.}
if [ "$orientation" = "left" ]; then
	target=${target%.*}
else
	unset orientation
fi
: ${target:?undefined}
: ${sizes:?no size specified}
: ${replace:=1}
: ${dry_run:=0}

set -- $base_size_line
base_size=$1
: ${base_size:?undefined}
base_hotspot_x=$2
: ${base_hotspot_x:?undefined}
base_hotspot_y=$3
: ${base_hotspot_y:?undefined}

for s in $sizes; do
	if [ "$orientation" ]; then
		config_file=hotspots/${s}/${target}_${orientation}.in
		source_png=${target}.${s}.${orientation}.png
	else
		config_file=hotspots/${s}/${target}.in
		source_png=${target}.${s}.png
	fi
	if [ -e $config_file -a "$replace" = "0" ]; then
		echo "$config_file: skipping $s" >&2
		continue
	fi
	[ "$dry_run" = "0" ] && rm -f $config_file
	hotspot_x=$(calc "($s * $base_hotspot_x) / $base_size")
	hotspot_y=$(calc "($s * $base_hotspot_y) / $base_size")
	: ${hotspot_x:?undefined}
	: ${hotspot_y:?undefined}
	output="${s} ${hotspot_x} ${hotspot_y} $source_png"
	echo "$config_file: $output"
	[ "$dry_run" = "0" ] && echo "${output}" >> $config_file
	base_size=$((base_size + s))
	base_hotspot_x=$((hotspot_x + base_hotspot_x))
	base_hotspot_y=$((hotspot_y + base_hotspot_y))
done
