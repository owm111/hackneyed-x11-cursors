#!/bin/bash

# Copyright (C) Ludvig Hummel
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR THE COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Except as contained in this notice, the name(s) of the above copyright
# holders shall not be used in advertising or otherwise to promote the sale,
# use or other dealings in this Software without prior written authorization.

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
