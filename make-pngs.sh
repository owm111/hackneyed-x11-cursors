#!/bin/bash

. sh-functions
parse_cmdline "$@"
xmkdir png $sizes

svg="svg/${target}.svg"
[ "$with_svg" ] && svg=$with_svg
if [ "$orientation" = "left" ]; then
	if [ -e "svg/${target}_left.svg" ]; then
		svg="svg/${target}_left.svg"
	else
		echo -n "no left-handed SVG for ${target}; "
		if [ -e config/flip/${target} ]; then
			echo "image will be flipped"
			flop='-flop'
		else
			echo "no need for flipping"
		fi
	fi
	target="${target}_left"
fi
source_png="png/${target}.png"

if [ -x config/overlay/${target} ]; then
	echo "found overlay config/overlay/${target}"
	source config/overlay/${target}
	: ${svg:?unset}
	: ${overlay:?unset}
	if ! [ -e $overlay ]; then
		echo "${overlay}.svg not found"
		exit 1
	fi
	: ${overlay_size:=50}
	: ${overlay_position:?unset}
	if [ "$flip_svg" = "1" ]; then
		flop='-flop'
		source_png="png/$(basename $svg .svg)_flipped.png"
	else
		source_png="png/$(basename $svg .svg).png"
	fi
fi

if ! [ -e $svg ]; then
	echo "${target}.svg does not exist"
	exit 1
fi
export_png opt=$flop src=$svg dest=$source_png

if [ "$overlay" ]; then
	source_ovl="png/${target}.png"
	tmp_ovl="$(basename $overlay .svg).png"
	echo "generating $source_ovl"
	export_png opt='-trim +repage' src=$overlay dest=$tmp_ovl
	composite -background none -geometry $overlay_position \( $tmp_ovl -resize ${overlay_size}% \) \
		$source_png $source_ovl || exit 1 && rm $tmp_ovl
	source_png=$source_ovl
fi

for s in $sizes; do
	png_name="${s}/${target}.png"
	transform size=${s} src=$source_png dest=$png_name || exit 1
	[ -x config/transform/${target} ] && source config/transform/${target}
done

exit 0
