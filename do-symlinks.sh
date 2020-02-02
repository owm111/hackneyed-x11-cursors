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

SOURCE_DIR=$(dirname $0)
[ "$SOURCE_DIR"  = "." ] && SOURCE_DIR=$PWD
SOURCE_FILE="${SOURCE_DIR}/theme/symlinks"

die()
{
	echo "$(basename $0): $@"
	exit 1
}

link()
{
	[ "$1" -a "$2" ] || die "internal error"

	if [ -e "$1" ] && ! [ -e "$2" ]; then
		echo "$1: $2"
		ln -s "$1" "$2" || exit 1
	fi
}

deref_symlink()
{
	for a in $cursor $symlinks; do
		if [ -e $a ]; then
			echo $(readlink $a || echo $a)
			return 0
		fi
	done
	return 1
}

do_linkage()
{
	while IFS="$(echo -e '\t')" read cursor symlinks; do
		c_source=$(deref_symlink)
		if [ -e "$c_source" ]; then
			for a in $symlinks; do
				link $c_source $a
				[ ! -e "$cursor" ] && link $c_source $cursor
			done
		elif [ "$c_source" ]; then
			echo "::: [missing: $c_source]"
		fi
		unset c_source
	done < $SOURCE_FILE || exit 1
}

oldwd=$PWD
[ $# = 0 ] && set -- .
while [ "$1" ]; do
	cd $1 || exit 1
	do_linkage
	cd $oldwd || exit 1
	shift
done
