#!/bin/sh
cursors="alias color-picker context-menu copy default help pencil dnd-move zoom zoom-in zoom-out no-drop draft right_ptr openhand closedhand pointer coffee_mug exchange"
common="text vertical-text sb_up_arrow sb_down_arrow sb_left_arrow sb_right_arrow pirate based_arrow_up based_arrow_down ns-resize ew-resize nwse-resize nesw-resize move plus crosshair n-resize s-resize w-resize e-resize nw-resize ne-resize sw-resize se-resize center_ptr all-scroll not-allowed draped_box wayland-cursor X_cursor ul_angle ur_angle ll_angle lr_angle split_v split_h top_tee bottom_tee left_tee right_tee"
waitFrames=$(printf 'wait-%s\n' $(seq 1 16))
progressFrames=$(printf 'progress-%s\n' $(seq 1 16))

# Make .ins
mkdir -p build/{white,dark,in}
for x in $cursors $common; do
  cat theme/*/$x.in > build/in/$x.in
done
for x in progress wait; do
  cat theme/*/$x.in | while read dpi w h name; do
    for i in $(seq 1 16); do
      echo "$dpi $w $h $x-$i.$dpi.png $(( i == 5 ? 300 : 30 ))"
    done
  done > build/in/$x.in
done

# Make .pngs
for theme in white dark; do
  if [ $theme = white ]; then
    name=Hackneyed_White
  else
    name=Hackneyed_Dark
  fi
  mkdir -p $out/share/icons/$name/cursors
  echo export-type:png
  echo file-open:theme/right-handed-$theme.svg
  for i in 24 36 48 60 72; do
    echo export-dpi:$(( i * 4 ))
    for x in $progressFrames $cursors; do
      echo export-id:$x
      echo export-filename:build/$theme/$x.$i.png
      echo export-do
    done
  done
  echo file-open:theme/common-$theme.svg
  for i in 24 36 48 60 72; do
    echo export-dpi:$(( i * 4 ))
    for x in $waitFrames $common; do
      echo export-id:$x
      echo export-filename:build/$theme/$x.$i.png
      echo export-do
    done
  done
done | inkscape --shell

# Make cursors
for theme in white dark; do
  if [ $theme = white ]; then
    name=Hackneyed_White
  else
    name=Hackneyed_Dark
  fi
  for x in $cursors $common wait progress; do
    xcursorgen -p build/$theme build/in/$x.in $out/share/icons/$name/cursors/$x
  done
  echo built
  while IFS="$(printf '\t')" read x ys; do
    for y in $ys; do
      ln -Lsr $out/share/icons/$name/cursors/$x $out/share/icons/$name/cursors/$y || true
    done
  done < theme/symlinks
  cat <<EOF > $out/share/icons/$name/index.theme
[Icon Theme]
Name = $name (scalable)
Comment = Windows 3.x-inspired cursors
Example = progress
EOF
done

# Remove dead links
find $out/share/icons -xtype l -delete
