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

CURSORS = default text pointer help progress wait copy alias no-drop \
not-allowed split_v split_h e-resize ne-resize nw-resize n-resize se-resize \
sw-resize s-resize w-resize vertical-text crosshair up_arrow \
context-menu ew-resize ns-resize nesw-resize nwse-resize pencil right_ptr \
zoom zoom-in zoom-out pirate X_cursor closedhand openhand color-picker plus \
center_ptr move all-scroll dnd-move wayland-cursor down_arrow draft \
left_arrow right_arrow exchange ul_angle ur_angle ll_angle lr_angle \
based_arrow_down based_arrow_up top_tee bottom_tee left_tee right_tee \
draped_box coffee_mug
LCURSORS = alias.left color-picker.left context-menu.left copy.left \
default.left help.left pencil.left dnd-move.left zoom-in.left zoom.left \
zoom-out.left progress.left no-drop.left draft.left right_ptr.left \
openhand.left closedhand.left pointer.left coffee_mug.left exchange.left
THEME_NAME = Hackneyed
VERSION = 0.4
SIZES ?= 32 40 48 56 64
PREVIEW_SIZE = 48
XCURSORGEN = xcursorgen
.DEFAULT_GOAL = pack
PREFIX ?= /usr/local

install: theme theme.left
	test -e $(DESTDIR)$(PREFIX)/share/icons || install -d -m755 $(DESTDIR)$(PREFIX)/share/icons
	cp -a $(THEME_NAME) L$(THEME_NAME) -t $(DESTDIR)$(PREFIX)/share/icons

pack: theme theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-pack.tar.bz2 $(THEME_NAME) L$(THEME_NAME)

source-dist:
	git archive --format=tar.gz --prefix=hackneyed-x11-cursors-$(VERSION)/ HEAD > \
		hackneyed-x11-cursors-$(VERSION).tar.gz

dist: theme
	tar -jcof $(THEME_NAME)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME)

ldist: theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME)

theme: all
	./generate-metadata.sh target=$@ sizes="$(SIZES)" > $(THEME_NAME)/index.theme
	./do-symlinks.sh $(THEME_NAME)/cursors

theme.left: lall
	./generate-metadata.sh target=$@ sizes="$(SIZES)" > L$(THEME_NAME)/index.theme
	./do-symlinks.sh L$(THEME_NAME)/cursors

all: $(CURSORS)
	test -d $(THEME_NAME) && rm -rf $(THEME_NAME) || true
	mkdir -p $(THEME_NAME)/cursors
	cp $(CURSORS) $(THEME_NAME)/cursors
#	echo \(trim-cursor-files "\"$(THEME_NAME)/cursors/*\""\)|cat trim-cursor-files.scm - |gimp -i -b -

lall: $(CURSORS) $(LCURSORS)
	test -d L$(THEME_NAME) && rm -rf L$(THEME_NAME) || true
	mkdir -p L$(THEME_NAME)/cursors
	cp $(CURSORS) L$(THEME_NAME)/cursors
	for l in $(LCURSORS); do \
		cp $$l L$(THEME_NAME)/cursors/$${l/.left/}; \
	done
#	echo \(trim-cursor-files "\"L$(THEME_NAME)/cursors/*\""\)|cat trim-cursor-files.scm - |gimp -i -b -

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

preview: $(CURSORS) $(LCURSORS)
	montage -background none -geometry +4+4 -mode concatenate -tile 9x10 \
		$(PREVIEW_SIZE)/{default,help,progress,alias,copy,context-menu,no-drop,dnd-move}.png \
		$(PREVIEW_SIZE)/{help,progress,alias,copy,context-menu,no-drop,dnd-move}_left.png \
		$(PREVIEW_SIZE)/{default_left,center_ptr,right_ptr_left}.png \
		$(PREVIEW_SIZE)/{pencil_left,color-picker_left,openhand}.png \
		$(PREVIEW_SIZE)/{nw-resize,n-resize,ne-resize,split_v,split_h}.png \
		$(PREVIEW_SIZE)/{zoom,zoom-in,zoom-out,closedhand}.png \
		$(PREVIEW_SIZE)/{w-resize,wait,e-resize,text,ew-resize}.png \
		$(PREVIEW_SIZE)/{ns-resize,nesw-resize,nwse-resize}.png \
		$(PREVIEW_SIZE)/{pointer,sw-resize}.png \
		$(PREVIEW_SIZE)/{s-resize,se-resize,vertical-text}.png \
		$(PREVIEW_SIZE)/{zoom,zoom-in,zoom-out}_left.png \
		$(PREVIEW_SIZE)/{move,crosshair,plus}.png \
		$(PREVIEW_SIZE)/{not-allowed,pencil}.png \
		$(PREVIEW_SIZE)/{pirate,color-picker,X_cursor,draft}.png \
		$(PREVIEW_SIZE)/{up_arrow,right_arrow,down_arrow,left_arrow,all-scroll,wayland-cursor}.png \
		preview.png

Makefile.in Makefile: ;
%.svg: ;
%.mk: ;
config/overlay/%: ;
config/transform/%: ;
%.sh: ;

clean:
	rm -rf $(SIZES)
	rm -rf $(THEME_NAME) L$(THEME_NAME)
	rm -f *.in *.in_left
	rm -f $(CURSORS) $(LCURSORS)
	rm -rf png

.PHONY: preview clean theme theme.left all lall dist ldist pack
.PRECIOUS: %.in %.in_left
