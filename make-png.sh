#!/usr/bin/env bash
#
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

MYNAME="$(basename $0)"
: ${INKSCAPE:=/usr/bin/inkscape}

die()
{
	echo $@ >&2
	exit 1
}

ikwrapper()
{
	local export_id

	ikver=$($INKSCAPE --version|cut -d' ' -f2)
	[ -z "$ikver" ] && die "could not determine Inkscape version"
	while [ "$1" ]; do
		case "$1" in
		export_id=*)
			export_id=${1#*=}
			shift ;;
		*)
			die "wrapper: internal error"
			shift ;;
		esac
	done
	if [ "${ikver:0:3}" = "1.0" ]; then
		# Oh cool, Inkscape returns zero even if ID isn't found!
		LANG=C $INKSCAPE -z -d $dpi --export-id="$export_id" --export-file="$output" "$src" 2>&1|grep -q 'was not found' && \
			die "$MYNAME: object ID not found in $src"
		return 0
	fi
	$INKSCAPE -z -d $dpi -i "$export_id" -f "$src" -e "$output" >/dev/null || die
}

while [ "$1" ]; do
	case "$1" in
	src=*)
		src=${1#*=}
		shift ;;
	target=*)
		target=${1#*=}
		shift ;;
	size=*)
		size=${1#*=}
		shift ;;
	smallest_size=*)
		smallest_size=${1#*=}
		shift ;;
	output=*)
		output=${1#*=}
		shift ;;
	frames=*)
		frames=${1#*=}
		shift ;;
	*)
		die "invalid parameter: $1"
	esac
done

: ${src:?no source svg specified}
: ${target:?missing target}
: ${size:?no size specified}
: ${smallest_size:?missing smallest size}

dpi=$(( (96 * size) / smallest_size ))
: ${dpi:?invalid size $size}
variant=${target#*.}
[ "$variant" = "$target" ] && unset variant
[ "$variant" ] && target=${target%.*}

if (( frames > 1 )); then
	for ((i = 1; i <= frames; i++)); do
		[ "$variant" ] && output="${target}-${i}.${size}.${variant}.png" || output="${target}-${i}.${size}.png"
		echo "$MYNAME: $target ($size): $output"
		ikwrapper export_id="${target}-${i}"
	done
	exit 0
fi

: ${output:?no outfile specified}
echo "$MYNAME: ${target}: ${output}, ${size}px, ${dpi} DPI"; \
ikwrapper export_id=$target
