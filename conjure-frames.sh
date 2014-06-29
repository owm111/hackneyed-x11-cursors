#!/bin/bash

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
		echo "$png_name"
		export_png src=$source_svg dest=$png_name size=${s}
		[ $j = 9 ] && duration=360
		echo "$s $size_half $size_half $png_name $duration" >> $config_file
		((j++))
		source_svg="svg/${target}-${j}.svg"
	done
	starts_spinning=$png_name
	for ((i=6; i<180; i+=6, j++)); do
		png_name="${s}/${target}-${j}.png"
		echo "$starts_spinning: $png_name"
		convert -resize ${s}x${s} -distort SRT +${i} $starts_spinning $png_name || exit 1
		echo "$s $size_half $size_half $png_name 30" >> $config_file
	done
done
