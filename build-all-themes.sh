#!/bin/bash
nprocs=$(getconf _NPROCESSORS_ONLN)
: ${nprocs:=4}
nprocs=$((nprocs+1))
make clean && make -j${nprocs} all-dist preview windows-cursors && \
make clean && make COMMON_SOURCE=theme/common-dark.svg RSVG_SOURCE=theme/right-handed-dark.svg LSVG_SOURCE=theme/left-handed-dark.svg THEME_NAME=Hackneyed-Dark -j${nprocs} all-dist preview windows-cursors
