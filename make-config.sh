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

case $orientation in
*left)
	dest=${target}.in_left
	overlay_name=${target}
	orientation=in_left
	;;
in|*)
	dest=${target}.in
	overlay_name=${target}
	orientation=in
	;;
esac
rm -f $dest

for s in $sizes; do
	if ! [ -e config/$s ]; then
		echo "size $s not found"
		exit 1
	fi
	source_file=config/${s}/${dest}
	if ! [ -e $source_file ]; then
		if [ -e config/overlay/${overlay_name} ]; then
			replace_with=${overlay_name}.png
			echo "$source_file was not found, using basic target from overlay"
			source config/overlay/${overlay_name} || exit 1
			: ${svg:?undefined}
			source_file="config/${s}/$(basename $svg .svg).${orientation}"
			png_name=$(basename $(cut -d' ' -f4 $source_file))
			: ${png_name:?undefined}
		else
			die "No source file was found"
		fi
	fi
	if [ "$replace_with" ]; then
		sed "s/$png_name/$replace_with/g" $source_file >> $dest
	else
		cat $source_file >> $dest || exit 1
	fi
	unset replace_with
done
