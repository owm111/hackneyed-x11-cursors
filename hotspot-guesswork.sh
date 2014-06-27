#!/bin/bash

LC_NUMERIC=C

while [ "$1" ]; do
	case "$1" in
	sizes=*)
		sizes=${1#*=}
		shift
		;;
	base_size_line=*)
		base_size_line=${1#*=}
		shift
		;;
	replace=*)
		replace=${1#*=}
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
: ${sizes:?no size specified}
: ${replace:=1}
: ${dry_run:=0}

[ -z "$base_size_line" ] && base_size_line=$(< config/32/$c)
: ${base_size_line:?undefined}

for s in $sizes; do
	size_int=${s%x*}
	config_file=config/${s}/${c}
	if [ -e $config_file -a "$replace" = "0" ]; then
		echo "$config_file: skipping $s" >&2
		continue
	fi
	base_size=$(echo $base_size_line|cut -d' ' -f1)
	: ${base_size:?undefined}
	hotspots=($(echo "$base_size_line"|cut -d' ' -f2,3))
	: ${hotspots:?undefined}
	filename=$(echo $base_size_line|cut -d' ' -f4)
	: ${filename:?undefined}
	[ "$debug_print" ] || echo "using $base_size ${hotspots[@]} $filename as base size"
	debug_print=1
	for n in ${hotspots[@]}; do
		result=$(echo -e scale=2\\n$n \* \($size_int / $base_size\)|bc)
		result=$(printf '%.0f' $result)
		new_hotspots="$new_hotspots $result"
	done
	: ${new_hotspots:?undefined}
	newsize="${size_int}${new_hotspots} ${s}/$(basename $filename)"
	unset new_hotspots
	echo "$config_file: $newsize"
	[ "$dry_run" = "1" ] || echo "${newsize}" > $config_file
done
