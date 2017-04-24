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

CURSORS_32 = default.32 text.32 pointer.32 help.32 progress.32 wait.32 copy.32 alias.32 no-drop.32 \
not-allowed.32 split_v.32 split_h.32 e-resize.32 ne-resize.32 nw-resize.32 n-resize.32 se-resize.32 \
sw-resize.32 s-resize.32 w-resize.32 vertical-text.32 crosshair.32 up_arrow.32 \
context-menu.32 ew-resize.32 ns-resize.32 nesw-resize.32 nwse-resize.32 pencil.32 right_ptr.32 \
zoom.32 zoom-in.32 zoom-out.32 pirate.32 X_cursor.32 closedhand.32 openhand.32 color-picker.32 plus.32 \
center_ptr.32 move.32 all-scroll.32 dnd-move.32 wayland-cursor.32 down_arrow.32 draft.32 \
left_arrow.32 right_arrow.32 exchange.32 ul_angle.32 ur_angle.32 ll_angle.32 lr_angle.32 \
based_arrow_down.32 based_arrow_up.32 top_tee.32 bottom_tee.32 left_tee.32 right_tee.32 \
draped_box.32 coffee_mug.32
CURSORS_48 = $(CURSORS_32:.32=.48)
CURSORS_64 = $(CURSORS_32:.32=.64)
CURSORS = $(CURSORS_32:.32=)
LCURSORS_32 = alias.32.left color-picker.32.left context-menu.32.left copy.32.left \
default.32.left help.32.left pencil.32.left dnd-move.32.left zoom-in.32.left zoom.32.left \
zoom-out.32.left progress.32.left no-drop.32.left draft.32.left right_ptr.32.left \
openhand.32.left closedhand.32.left pointer.32.left coffee_mug.32.left exchange.32.left
LCURSORS_48 = $(LCURSORS_32:.32.left=.48.left)
LCURSORS_64 = $(LCURSORS_32:.32.left=.64.left)
LCURSORS = $(LCURSORS_32:.32.left=.left)
WINCURSORS = default.cur help.cur progress.cur wait.cur text.cur crosshair.cur pencil.cur \
ns-resize.cur ew-resize.cur nesw-resize.cur nwse-resize.cur up_arrow.cur pointer.cur move.cur \
n-resize.cur s-resize.cur e-resize.cur w-resize.cur ne-resize.cur nw-resize.cur se-resize.cur sw-resize.cur \
not-allowed.cur
WINCURSORS_LARGE = default_large.cur help_large.cur progress_large.cur wait_large.cur text_large.cur \
crosshair_large.cur pencil_large.cur ns-resize_large.cur ew-resize_large.cur nesw-resize_large.cur \
nwse-resize_large.cur up_arrow_large.cur pointer_large.cur move_large.cur n-resize_large.cur \
s-resize_large.cur e-resize_large.cur w-resize_large.cur ne-resize_large.cur nw-resize_large.cur \
se-resize_large.cur sw-resize_large.cur
LWINCURSORS = default_left.cur help_left.cur progress_left.cur pencil_left.cur pointer_left.cur
LWINCURSORS_LARGE = $(LWINCURSORS:_left.cur=_large_left.cur)
THEME_NAME = Hackneyed
THEME_NAME_32 = Hackneyed-32x32
THEME_NAME_48 = Hackneyed-48x48
THEME_NAME_64 = Hackneyed-64x64
THEME_COMMENT = Windows 3.x-inspired cursors
THEME_EXAMPLE = default
VERSION = 0.5.2
SIZES ?= 32 40 48 56 64
PREVIEW_SIZE = 48
XCURSORGEN = xcursorgen
.DEFAULT_GOAL = pack
PREFIX ?= /usr/local

all-dist: pack dist ldist dist.32 dist.48 dist.64 ldist.32 ldist.48 ldist.64

install: theme theme.left
	test -e $(DESTDIR)$(PREFIX)/share/icons || install -d -m755 $(DESTDIR)$(PREFIX)/share/icons
	cp -a $(THEME_NAME) L$(THEME_NAME) -t $(DESTDIR)$(PREFIX)/share/icons

pack: theme theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-pack.tar.bz2 $(THEME_NAME) L$(THEME_NAME)

source-dist:
	git archive --format=tar.gz --prefix=hackneyed-x11-cursors-$(VERSION)/ HEAD > \
		hackneyed-x11-cursors-$(VERSION).tar.gz

windows-cursors: $(WINCURSORS) $(WINCURSORS_LARGE) $(LWINCURSORS) $(LWINCURSORS_LARGE)
	rm -rf Hackneyed-Windows
	mkdir -p Hackneyed-Windows/{King-size,Standard}
	cp $(WINCURSORS_LARGE) $(LWINCURSORS_LARGE) Hackneyed-Windows/King-size
	cp $(WINCURSORS) $(LWINCURSORS) Hackneyed-Windows/Standard
	7z a Hackneyed-Windows.7z Hackneyed-Windows

dist: theme
	tar -jcof $(THEME_NAME)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME)

ldist: theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME)

dist.32: theme.32
	tar -jcof $(THEME_NAME_32)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_32)

dist.48: theme.48
	tar -jcof $(THEME_NAME_48)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_48)

dist.64: theme.64
	tar -jcof $(THEME_NAME_64)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_64)

ldist.32: theme.32.left
	tar -jcof $(THEME_NAME_32)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_32)

ldist.48: theme.48.left
	tar -jcof $(THEME_NAME_48)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_48)

ldist.64: theme.64.left
	tar -jcof $(THEME_NAME_64)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_64)

theme: all
	./generate-metadata.sh target=$@ sizes="$(SIZES)" theme_name='$(THEME_NAME)' \
		theme_comment='$(THEME_COMMENT)' theme_example='$(THEME_EXAMPLE)' \
		> $(THEME_NAME)/index.theme
	./do-symlinks.sh $(THEME_NAME)/cursors

theme.left: lall
	./generate-metadata.sh target=$@ sizes="$(SIZES)" theme_name='$(THEME_NAME)' \
		theme_comment='$(THEME_COMMENT)' theme_example='$(THEME_EXAMPLE)' \
		> L$(THEME_NAME)/index.theme
	./do-symlinks.sh L$(THEME_NAME)/cursors

theme.32: all.32
	./generate-metadata.sh target=$@ sizes=32 theme_name='$(THEME_NAME)' \
		theme_comment='$(THEME_COMMENT)' theme_example='$(THEME_EXAMPLE)' \
		> $(THEME_NAME_32)/index.theme
	./do-symlinks.sh $(THEME_NAME_32)/cursors

theme.48: all.48
	./generate-metadata.sh target=$@ sizes=48 theme_name='$(THEME_NAME)' \
		theme_comment='$(THEME_COMMENT)' theme_example='$(THEME_EXAMPLE)' \
		> $(THEME_NAME_48)/index.theme
	./do-symlinks.sh $(THEME_NAME_48)/cursors

theme.64: all.64
	./generate-metadata.sh target=$@ sizes=64 theme_name='$(THEME_NAME)' \
		theme_comment='$(THEME_COMMENT)' theme_example='$(THEME_EXAMPLE)' \
		> $(THEME_NAME_64)/index.theme
	./do-symlinks.sh $(THEME_NAME_64)/cursors

theme.32.left: lall.32
	./generate-metadata.sh target=$@ sizes=32 theme_name='$(THEME_NAME)' \
		theme_comment='$(THEME_COMMENT)' theme_example='$(THEME_EXAMPLE)' \
		> L$(THEME_NAME_32)/index.theme
	./do-symlinks.sh L$(THEME_NAME_32)/cursors

theme.48.left: lall.48
	./generate-metadata.sh target=$@ sizes=48 theme_name='$(THEME_NAME)' \
		theme_comment='$(THEME_COMMENT)' theme_example='$(THEME_EXAMPLE)' \
		> L$(THEME_NAME_48)/index.theme
	./do-symlinks.sh L$(THEME_NAME_48)/cursors

theme.64.left: lall.64
	./generate-metadata.sh target=$@ sizes=64 theme_name='$(THEME_NAME)' \
		theme_comment='$(THEME_COMMENT)' theme_example='$(THEME_EXAMPLE)' \
		> L$(THEME_NAME_64)/index.theme
	./do-symlinks.sh L$(THEME_NAME_64)/cursors

all: $(CURSORS)
	rm -rf $(THEME_NAME)
	mkdir -p $(THEME_NAME)/cursors
	cp $(CURSORS) $(THEME_NAME)/cursors
#	echo \(trim-cursor-files "\"$(THEME_NAME)/cursors/*\""\)|cat trim-cursor-files.scm - |gimp -i -b -

lall: $(CURSORS) $(LCURSORS)
	rm -rf L$(THEME_NAME)
	mkdir -p L$(THEME_NAME)/cursors
	cp $(CURSORS) L$(THEME_NAME)/cursors
	for l in $(LCURSORS); do \
		cp $$l L$(THEME_NAME)/cursors/$${l/.left/}; \
	done
#	echo \(trim-cursor-files "\"L$(THEME_NAME)/cursors/*\""\)|cat trim-cursor-files.scm - |gimp -i -b -

all.32: $(CURSORS_32)
	rm -rf $(THEME_NAME_32)
	mkdir -p $(THEME_NAME_32)/cursors
	cp $(CURSORS_32) $(THEME_NAME_32)/cursors
	rename .32 '' $(THEME_NAME_32)/cursors/*

all.48: $(CURSORS_48)
	rm -rf $(THEME_NAME_48)
	mkdir -p $(THEME_NAME_48)/cursors
	cp $(CURSORS_48) $(THEME_NAME_48)/cursors
	rename .48 '' $(THEME_NAME_48)/cursors/*

all.64: $(CURSORS_64)
	rm -rf $(THEME_NAME_64)
	mkdir -p $(THEME_NAME_64)/cursors
	cp $(CURSORS_64) $(THEME_NAME_64)/cursors
	rename .64 '' $(THEME_NAME_64)/cursors/*

lall.32: $(CURSORS_32) $(LCURSORS_32)
	rm -rf L$(THEME_NAME_32)
	mkdir -p L$(THEME_NAME_32)/cursors
	cp $(CURSORS_32) L$(THEME_NAME_32)/cursors
	rename .32 '' L$(THEME_NAME_32)/cursors/*
	for l in $(LCURSORS_32); do \
		cp $$l L$(THEME_NAME_32)/cursors/$${l/.32.left/}; \
	done

lall.48: $(CURSORS_48) $(LCURSORS_48)
	rm -rf L$(THEME_NAME_48)
	mkdir -p L$(THEME_NAME_48)/cursors
	cp $(CURSORS_48) L$(THEME_NAME_48)/cursors
	rename .48 '' L$(THEME_NAME_48)/cursors/*
	for l in $(LCURSORS_48); do \
		cp $$l L$(THEME_NAME_48)/cursors/$${l/.48.left/}; \
	done

lall.64: $(CURSORS_64) $(LCURSORS_64)
	rm -rf L$(THEME_NAME_64)
	mkdir -p L$(THEME_NAME_64)/cursors
	cp $(CURSORS_64) L$(THEME_NAME_64)/cursors
	rename .64 '' L$(THEME_NAME_64)/cursors/*
	for l in $(LCURSORS_64); do \
		cp $$l L$(THEME_NAME_64)/cursors/$${l/.64.left/}; \
	done

%.in: config/*/%.in
	./make-config.sh sizes="$(SIZES)" target=$@

%.in_left: config/*/%.in_left
	./make-config.sh sizes="$(SIZES)" target=$@

%: %.in src/table-cloth.svg
	./make-pngs.sh target=$@ sizes="$(SIZES)"
	$(XCURSORGEN) $< $@

%.left: %.in_left src/wristband.svg
	./make-pngs.sh target=$@ sizes="$(SIZES)"
	$(XCURSORGEN) $< $@

%.32: config/32/%.in src/table-cloth.svg
	./make-pngs.sh target=$@ sizes=32
	$(XCURSORGEN) $< $@

%.48: config/48/%.in src/table-cloth.svg
	./make-pngs.sh target=$@ sizes=48
	$(XCURSORGEN) $< $@

%.64: config/64/%.in src/table-cloth.svg
	./make-pngs.sh target=$@ sizes=64
	$(XCURSORGEN) $< $@

%.32.left: config/32/%.in_left src/wristband.svg
	./make-pngs.sh target=$@ sizes=32
	$(XCURSORGEN) $< $@

%.48.left: config/48/%.in_left src/wristband.svg
	./make-pngs.sh target=$@ sizes=48
	$(XCURSORGEN) $< $@

%.64.left: config/64/%.in_left src/wristband.svg
	./make-pngs.sh target=$@ sizes=64
	$(XCURSORGEN) $< $@

ico2cur: ico2cur.c
	$(CC) -std=c99 -Wall -Werror -pedantic -g -o ico2cur ico2cur.c

%.cur: ico2cur src/prosthesis.svg config/cur/hotspots
	{ \
		dest_png=$(@:.cur=.png); \
		dest_ico=$(@:.cur=.ico); \
		target=$(@:.cur=); \
		inkscape --without-gui -i $$target -f src/prosthesis.svg -e $$dest_png >/dev/null && \
			convert $$dest_png $$dest_ico && rm -f $$dest_png && \
			./ico2cur -p config/cur/hotspots $$dest_ico && \
			rm -f $$dest_ico; \
	}

preview: $(CURSORS) $(LCURSORS)
	montage -background none -geometry +4+4 -mode concatenate -tile 9x10 \
		$(PREVIEW_SIZE)/{default,help,progress,alias,copy,context-menu,no-drop,dnd-move}.png \
		$(PREVIEW_SIZE)/{help,progress,alias,copy,context-menu,no-drop,dnd-move,default}_left.png \
		$(PREVIEW_SIZE)/{center_ptr,right_ptr_left,wait,openhand}.png \
		$(PREVIEW_SIZE)/{pointer,closedhand,sw-resize,se-resize,w-resize,e-resize}.png \
		$(PREVIEW_SIZE)/{n-resize,s-resize,nw-resize,ne-resize,split_v,zoom,zoom-in,zoom-out,nesw-resize}.png \
		$(PREVIEW_SIZE)/{nwse-resize,ew-resize,ns-resize,split_h}.png \
		$(PREVIEW_SIZE)/{text,vertical-text,move,crosshair,plus,not-allowed}.png \
		$(PREVIEW_SIZE)/{pirate,X_cursor,wayland-cursor,draft,pencil,color-picker}.png \
		$(PREVIEW_SIZE)/{up_arrow,right_arrow,left_arrow}.png \
		preview.png

Makefile.in Makefile: ;
%.svg: ;
%.mk: ;
%.sh: ;

clean:
	rm -rf $(SIZES)
	rm -rf $(THEME_NAME) L$(THEME_NAME) $(THEME_NAME_32) $(THEME_NAME_48) $(THEME_NAME_64) L$(THEME_NAME_32) L$(THEME_NAME_48) L$(THEME_NAME_64)
	rm -f $(CURSORS) $(CURSORS_32) $(CURSORS_48) $(CURSORS_64) $(LCURSORS) $(LCURSORS_32) $(LCURSORS_48) $(LCURSORS_64)
	rm -f Hackneyed-Windows.7z
	rm -f $(WINCURSORS) $(WINCURSORS_LARGE) $(LWINCURSORS) $(LWINCURSORS_LARGE)

.PHONY: preview clean theme theme.left all lall dist ldist pack all-dist windows-cursors
