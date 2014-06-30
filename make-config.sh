#!/bin/bash

. sh-functions
parse_cmdline "$@"

: ${orientation:=in}
dest=${target}.${orientation}

rm -f $dest
case $orientation in
	*left)
		overlay_name=${target}_left ;;
	*)
		overlay_name=${target} ;;
esac

for s in $sizes; do
	if ! [ -e config/$s ]; then
		echo "size $s not found"
		exit 1
	fi
	source_file=config/${s}/${dest}
	if ! [ -e $source_file -a -e config/overlay/${overlay_name} ]; then
		replace_with=${overlay_name}.png
		echo "$source_file was not found, using basic target from overlay"
		source config/overlay/${overlay_name} || exit 1
		: ${svg:?undefined}
		source_file="config/${s}/$(basename $svg .svg).${orientation}"
		png_name=$(basename $(cut -d' ' -f4 $source_file))
		: ${png_name:?undefined}
	fi
	if [ "$replace_with" ]; then
		sed "s/$png_name/$replace_with/g" $source_file >> $dest
	else
		cat $source_file >> $dest || exit 1
	fi
	unset replace_with
done
