#!/bin/bash

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
