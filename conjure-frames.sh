#!/bin/bash

# Copyright (C) Ludvig Hummel
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

parse_cmdline "$@"
xmkdir png $sizes
target=wait
config_file=${target}.in

rm -f $config_file

for s in $sizes; do
	size_half=$(((s / 2) - 1))
	j=1
	source_svg="svg/${target}-${j}.svg"
	while [ -e "$source_svg" ]; do
		duration=60
		png_name="${s}/$(basename $source_svg .svg).png"
		export_png src=$source_svg dest=$png_name size=${s}
		case $j in
		9)
			duration=666
			;;
		*)
			duration=60
			;;
		esac
		echo "$s $size_half $size_half $png_name $duration" >> $config_file
		((j++))
		source_svg="svg/${target}-${j}.svg"
	done
	starts_spinning=$png_name
	for ((i=6; i<180; i+=6, j++)); do
		png_name="${s}/${target}-${j}.png"
		tmp_crop="png/${target}-${j}.png"
		echo "$starts_spinning: $png_name"
#		convert -resize ${s}x${s} -distort SRT +${i} $starts_spinning $png_name || exit 1
		convert -background none -resize ${s}x${s} -rotate ${i} $starts_spinning $tmp_crop || exit 1
		convert -gravity northwest -crop ${s}x${s}+0+0 $tmp_crop $png_name || exit 1
		echo "$s $size_half $size_half $png_name 30" >> $config_file
	done
done
