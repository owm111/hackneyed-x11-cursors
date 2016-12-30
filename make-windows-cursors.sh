#!/bin/bash

CURSORS="default help progress wait text crosshair pencil not-allowed
ns-resize ew-resize nesw-resize nwse-resize up_arrow pointer move
n-resize s-resize e-resize w-resize ne-resize nw-resize se-resize sw-resize"

with_svg="src/prosthesis.svg"

mkdir ico || exit 1

find_variants()
{
	leftlist="config/cur/left-handed"
	largelist="config/cur/large"
	
	[ "$1" ] || exit 255
	
	grep -Eq "(^|\W)$1($|\W)" $largelist && target_large=${1}_big
	if grep -Eq "(^|\W)$1($|\W)" $leftlist; then
		target_left=${1}_left
		target_large_left=${1}_big_left
	fi
}

get_hotspot()
{
	local cursor=$1
	hotspot=$(grep -E "(^|\W)$1($|\W)" config/cur/hotspots)
	[ ! "$hotspot" ] && unset hotspot
	: ${hotspot?no hotspot for $cursor}
	set -- $hotspot
	unset hotspot
	hotspot_x=$2
	hotspot_y=$3
	: ${hotspot_x?undefined}
	: ${hotspot_y?undefined}
}

generate_cur()
{
	target=$1
	get_hotspot $target
	dest_png="ico/${target}.png"
	dest_ico="ico/${target}.ico"
	echo "$target: $dest_ico (${hotspot_x},${hotspot_y})"
	inkscape --without-gui -i $target -f $with_svg -d 96 -e $dest_png >/dev/null || exit 1
	convert $dest_png $dest_ico || exit 1
	util/ico2cur $dest_ico -x $hotspot_x -y $hotspot_y || exit 1
}

for c in $CURSORS; do
	generate_cur $c
	find_variants $c
	[ "$target_large" ] && generate_cur $target_large
	[ "$target_left" ] && generate_cur $target_left
	[ "$target_large_left" ] && generate_cur $target_large_left
	unset target_large target_left target_large_left
done
mkdir -p Hackneyed-Windows/{Standard,King-size} || exit 1
mv ico/*_big*.cur Hackneyed-Windows/King-size || exit 1
mv ico/*.cur Hackneyed-Windows/Standard || exit 1
7z a Hackneyed-Windows.7z Hackneyed-Windows || exit 1
