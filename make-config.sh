#!/bin/bash

. sh-functions
parse_cmdline "$@"

dest=${target}.${orientation}

rm -f $dest
for s in $sizes; do
	if ! [ -e config/$s ]; then
		echo "size $s not found"
		exit 1
	fi
	cat config/${s}/${dest} >> $dest || exit 1
done
