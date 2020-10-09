#!/bin/sh
source $stdenv/setup
COMMON="text vertical-text sb_up_arrow sb_down_arrow sb_left_arrow sb_right_arrow pirate based_arrow_up based_arrow_down ns-resize ew-resize nwse-resize nesw-resize move plus crosshair n-resize s-resize w-resize e-resize nw-resize ne-resize sw-resize se-resize center_ptr all-scroll not-allowed draped_box wayland-cursor X_cursor ul_angle ur_angle ll_angle lr_angle split_v split_h top_tee bottom_tee left_tee right_tee"
CURSORS="alias color-picker context-menu copy default help pencil dnd-move zoom zoom-in zoom-out no-drop draft right_ptr openhand closedhand pointer coffee_mug exchange"
smallest=24
builddir=build-test
outdir=out
mkdir -p $builddir/in
mkdir -p $outdir
for x in $CURSORS $COMMON
do cat theme/*/$x.in > $builddir/in/$x.in
done
awk -vbuilddir=$builddir '{ name = $4; sub(/\.[0-9]+\.png/, "", name); for (i = 1; i <= 16; ++i) printf "%u %u %u %s-%u.%u.png %u\n", $1, $2, $3, name, i, $1, i == 5 ? 300 : 30 > builddir"/in/"name".in" }' theme/*/wait.in theme/*/progress.in
for theme in white dark
do mkdir -p $builddir/$theme
mkdir -p $outdir/$theme/cursors
if [ "$theme" = white ]
then fancy_name="Hackneyed-White"
else fancy_name="Hackneyed-Dark"
fi
for s in 24 36 48 60 72
do for x in $CURSORS
do printf 'theme/right-handed-%s.svg -d %u -i %s -e %s/%s.%u.png\n' $theme $((96 * s / smallest)) $x $builddir/$theme $x $s
done
for x in $COMMON
do printf 'theme/common-%s.svg -d %u -i %s -e %s/%s.%u.png\n' $theme $((96 * s / smallest)) $x $builddir/$theme $x $s
done
for i in $(seq 1 16)
do printf 'theme/common-%s.svg -d %u -i wait-%u -e %s/wait-%u.%u.png\n' $theme $((96 * s / smallest)) $i $builddir/$theme $i $s
printf 'theme/right-handed-%s.svg -d %u -i progress-%u -e %s/progress-%u.%u.png\n' $theme $((96 * s / smallest)) $i $builddir/$theme $i $s
done
done | $INKSCAPE --shell
for x in $CURSORS $COMMON wait progress
do $XCURSORGEN -p $builddir/$theme $builddir/in/$x.in $outdir/$theme/cursors/$x
done
while IFS="$(printf '\t')" read x ys
do for y in $ys
do ln -Lsr $outdir/$theme/cursors/$x $outdir/$theme/cursors/$y || true
done
done < theme/symlinks
cat <<EOF > $outdir/$theme/index.theme
[Icon Theme]
Name = $fancy_name (scalable)
Comment = Windows 3.x-inspired cursors
Example = progress
EOF
mkdir -p $out/share/icons/$fancy_name
cp -r $outdir/$theme/* $out/share/icons/$fancy_name
done
