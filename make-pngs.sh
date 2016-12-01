#!/bin/bash

# Copyright (C) Richard Ferreira
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
xmkdir $sizes
set -- $remaining_args

R_SOURCESVG="src/table-cloth.svg"
L_SOURCESVG="src/wristband.svg"

source_svg="$R_SOURCESVG"
[ "$with_svg" ] && source_svg=$with_svg || \
	if [ "$orientation" = "left" ]; then
		message "left-handed cursor"
		source_svg="$L_SOURCESVG"
		suffix="_left"
	fi

[ -e $svg ] || die "$svg does not exist"

# Better have some coffee
for s in $sizes; do
	dpi=$(( (96 * s)/32 ))
	dest_png="${s}/${target}${suffix}.png"
	message "dpi $dpi for ${s}px size -> $dest_png"
	inkscape --without-gui -i $target -d $dpi -f $source_svg -e $dest_png >/dev/null || exit 1
done

exit 0
