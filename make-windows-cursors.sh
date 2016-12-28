#!/bin/bash

CURSORS="default default_big help help_big progress progress_big  
wait text text_big crosshair crosshair_big pencil pencil_big
 not-allowed not-allowed_big ns-resize ns-resize_big ew-resize 
ew-resize_big nesw-resize nesw-resize_big nwse-resize nwse-resize_big up_arrow
up_arrow_big pointer pointer_big move move_big n-resize n-resize_big s-resize
s-resize_big e-resize e-resize_big w-resize w-resize_big ne-resize ne-resize_big
nw-resize nw-resize_big se-resize se-resize_big sw-resize sw-resize_big"
LCURSORS="default default_big help help_big progress progress_big
pencil pencil_big pointer pointer_big"

rm -rf ico
mkdir ico

has_lcursor()
{
	[ "$1" ] || exit 255
	for c in $LCURSORS; do
		[ "$c" = "$1" ] && return 0
	done
	return 1
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
	echo "$cursor: $hotspot_x $hotspot_y"
}

for c in $CURSORS; do
	get_hotspot $c
	dest_png="ico/${c}.png"
	dest_ico="ico/${c}.ico"
	echo "$c: $dest_ico"
	inkscape --without-gui -i $c -f src/prosthesis.svg -d 96 -e $dest_png >/dev/null || exit 1
	convert $dest_png $dest_ico || exit 1
	python ico2cur.py $dest_ico -x $hotspot_x -y $hotspot_y || exit 1
	if has_lcursor $c; then
		leftc="${c}_left"
		get_hotspot $leftc
		dest_pngl="ico/${c}_left.png"
		dest_icol="ico/${c}_left.ico"
		echo "$leftc: $dest_icol"
		inkscape --without-gui -i $leftc -f src/prosthesis.svg -d 96 -e $dest_pngl >/dev/null || exit 1
		convert $dest_pngl $dest_icol || exit 1
		python ico2cur.py $dest_icol -x $hotspot_x -y $hotspot_y || exit 1
	fi
done
rm -f ico/*.{png,ico}
