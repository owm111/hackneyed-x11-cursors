#!/bin/bash

. sh-functions
parse_cmdline "$@"
metadata=config/metadata
source $metadata || exit 1

: ${name:?undefined}
: ${comment:?undefined}
: ${example:?undefined}

set -- $sizes

(($# == 1)) && desc=" (${sizes}x${sizes})"
[ "$orientation" = "left" ] && desc="${desc} (left-handed version)"

cat <<-EOF
[Icon Theme]
Name = ${name}${desc}
Comment = $comment
Example = $example
EOF
