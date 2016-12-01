#!/bin/bash

CURSORS="default default_big help help_big progress progress_big  
wait wait_big text text_big crosshair crosshair_big pencil pencil_big
 not-allowed not-allowed_big ns-resize ns-resize_big ew-resize 
ew-resize_big nesw-resize nesw-resize_big nwse-resize nwse-resize_big up_arrow
up_arrow_big pointer pointer_big move move_big n-resize n-resize_big s-resize
e-resize w-resize ne-resize nw-resize se-resize sw-resize"
LH_CURSORS="default default_big help help_big progress progress_big
pencil pencil_big pointer pointer_big"

[ -e ico ] && rm -rf ico
mkdir -p ico
for c in $(CURSORS); do
	dest_ico="ico/${c}.ico"
	inkscape --without-gui -i $c -f src/prosthesis.svg -d 96 -e $dest_ico || exit 1
	
done
