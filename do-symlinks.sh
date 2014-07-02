#!/bin/bash

CURSORS="alias all_scroll dnd_copy dnd_move dnd_link move tcross closedhand
color_picker context_menu copy crosshair default e_resize ew_resize help
dnd_ask ne_resize nesw_resize no_drop not_allowed n_resize ns_resize nw_resize
nwse_resize openhand pencil pirate pointer progress right_ptr se_resize s_resize
sw_resize text up_arrow vertical_text wait w_resize X_cursor zoom zoom_in
zoom_out plus center_ptr vertical_text hand1 col_resize row_resize wayland_cursor
down_arrow left_arrow right_arrow draft exchange"

up_arrow="up-arrow sb_up_arrow"
down_arrow="sb_down_arrow e03881300220000010406080c0018102"
left_arrow="sb_left_arrow"
right_arrow="sb_right_arrow 4081077e9ffc7ff97e70604000000000"
plus="cell"
default="left_ptr top_left_arrow left-arrow"
right_ptr="arrow top_right_arrow right-arrow draft_large draft_small"
alias="link dnd-link 0876e1c15ff2fc01f906f1c363074c0f 3085a0e285430894940527032f8b26df 640fb0e74195791501fd1ed57b41487f a2a266d0498c3104214a47bd64ab0fc8 5c7388ec4f4bc7d0ebcb4687e87d5ddd"
not_allowed="forbidden circle crossed-circle crossed_circle 03b6e0fcb3499374a867c041f52298f0 310ebafe88f67c80876888b78f09609f 00c4610000d2e20000a3a50000439100"
no_drop="dnd-no-drop dnd-none 03b6e0fcb3499374a867c041f52298f0 03b6e0fcb3499374a867d041f52298f0 1001208387f90000800003000700f6ff"
pirate="kill"
wait="watch clock 0426c94ea35c87780ff01dc239897213"
progress="half-busy left_ptr_watch 00000000000000020006000e7e9ffc3f 08e8e1c95fe2fc01f976f1e063a24ccd 3ecb610c1bf2410f44200f48c40d3599 9116a3ea924ed2162ecab71ba103b17f"
help="left_ptr_help question_arrow whats_this gumby 5c6cd98b3f3ebcb1f9c7f1c204630408 d9ce0ab605698f320427677b458ad60b"
dnd_ask="$help"
ns_resize="size_ver sb_v_double_arrow v_double_arrow double_arrow 00008160000006810000408080010102"
n_resize="top_side"
s_resize="bottom_side"
ew_resize="size_hor sb_h_double_arrow h_double_arrow 028006030e0e7ebffc7f7070c0600140 800000020061340200cc660000580d80"
e_resize="right_side"
w_resize="left_side"
nw_resize="top_left_corner"
se_resize="bottom_right_corner"
nwse_resize="size_fdiag bd_double_arrow 38c5dff7c7b8962045400281044508d2 c7088f0f3e6c8088236ef8e1e3e70000 ul_angle lr_angle"
ne_resize="top_right_corner"
sw_resize="bottom_left_corner"
nesw_resize="size_bdiag fd_double_arrow 50585d75b494802d0151028115016902 fcf1c3c7cd4491d801f1e1c78f100000 ll_angle ur_angle"
dnd_move="4498f0e0c1937ffe01fd06f973665830 9081237383d90e509aa00f00170e968f 91532847acc1981c302e17af617818a7 4cb8584a4793df7081ff86f1716e5a10"
move="fleur dragging size_all all-scroll 9d800788f1b08800ae810202380a0822 fcf21c00b30f7e3f83fe0dfd12e71cff 0e133a0778f8f0a2f5b3088dc174c952"
closedhand="grabbing 208530c400c041818281048008011002"
openhand="5aca4d189052212118709018842178c0"
text="ibeam xterm 00601b0000c030000018060000308d00"
copy="dnd-copy 08ffe1cb5fe6fc01f906f1c063814ccf 1081e37283d90000800003c07f3ef6bf 6407b0e94181790501fd1e167b474872 b66166c04f8c3109214a4fbd64a50fc8 9d7388ef4fcbc1d0ebcf4583ea7555fd"
pointer="pointer2 pointing_hand hand hand2 e29285e634086352946a0e7090d73106"
tcross="cross target cross_reverse diamond_cross"
col_resize="split_v 2870a09082c103050810ffdffffe0204 c07385c7190e701020ff7ffffd08103c"
row_resize="split_h 14fef782d02440884392942c11205230 043a9f68147c53184671403ffa811cc5"
X_cursor="X-cursor"
context_menu="08ffe1e65f80fcfdf9fff11263e74c48"
zoom_out="zoom_out f41c0e382c97c0938e07017e42800402"
zoom_in="zoom_in f41c0e382c94c0958e07017e42b00462"
vertical_text="048008013003cff3c00c801001200000"
hand1="$pointer"
pencil="00ea0400004c4100001f8e0000628d00"

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

find_file()
{
	local alt_names=$@

	for a in $alt_names; do
		if [ -e $a ]; then
			[ -h $a ] && echo $(readlink $a) || echo $a
			return 0
		fi
	done
	return 1
}

do_linkage()
{
	for c in $CURSORS; do
		eval alt_names="\$$c"
		case $c in
		up_arrow|right_ptr|size_all|X_cursor|center_ptr)
			input=$c ;;
		*)
			input=${c/_/-} ;;
		esac

		[ "$alt_names" ] || echo "no alt_names for $input"
		if [ -e "$input" ]; then
			c_source=$input
		else
			c_source=$(find_file $alt_names)
			alt_names="$alt_names $input"
		fi
		if [ -z "$c_source" ]; then
			echo "missing: $input"
			continue
		fi

		for a in $alt_names; do
			link $c_source $a
		done
		unset c_source
	done
}

oldwd=$PWD
[ $# = 0 ] && set -- .
while [ "$1" ]; do
	cd $1 || exit 1
	do_linkage
	cd $oldwd || exit 1
	shift
done
