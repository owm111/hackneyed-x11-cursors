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

# Bashisms are a hell of a drug
SHELL = /bin/bash
RSVG_SOURCE = src/theme-main.svg
LSVG_SOURCE = src/theme-left.svg
WSVG_SOURCE = src/wc-large.svg
CURSORS_24 = default.24 text.24 pointer.24 help.24 progress.24 wait.24 copy.24 alias.24 no-drop.24 \
not-allowed.24 split_v.24 split_h.24 e-resize.24 ne-resize.24 nw-resize.24 n-resize.24 se-resize.24 \
sw-resize.24 s-resize.24 w-resize.24 vertical-text.24 crosshair.24 up_arrow.24 \
context-menu.24 ew-resize.24 ns-resize.24 nesw-resize.24 nwse-resize.24 pencil.24 right_ptr.24 \
zoom.24 zoom-in.24 zoom-out.24 pirate.24 X_cursor.24 closedhand.24 openhand.24 color-picker.24 plus.24 \
center_ptr.24 move.24 all-scroll.24 dnd-move.24 wayland-cursor.24 down_arrow.24 draft.24 \
left_arrow.24 right_arrow.24 exchange.24 ul_angle.24 ur_angle.24 ll_angle.24 lr_angle.24 \
based_arrow_down.24 based_arrow_up.24 top_tee.24 bottom_tee.24 left_tee.24 right_tee.24 \
draped_box.24 coffee_mug.24
CURSORS_36 = $(CURSORS_24:.24=.36)
CURSORS_48 = $(CURSORS_24:.24=.48)
CURSORS_60 = $(CURSORS_24:.24=.60)
CURSORS_72 = $(CURSORS_24:.24=.72)
CURSORS = $(CURSORS_24:.24=)
PNG_24 = $(CURSORS_24:.24=.24.png)
PNG_36 = $(CURSORS_24:.24=.36.png)
PNG_48 = $(CURSORS_24:.24=.48.png)
PNG_60 = $(CURSORS_24:.24=.60.png)
PNG_72 = $(CURSORS_24:.24=.72.png)
LCURSORS_24 = alias.24.left color-picker.24.left context-menu.24.left copy.24.left \
default.24.left help.24.left pencil.24.left dnd-move.24.left zoom-in.24.left zoom.24.left \
zoom-out.24.left progress.24.left no-drop.24.left draft.24.left right_ptr.24.left \
openhand.24.left closedhand.24.left pointer.24.left coffee_mug.24.left exchange.24.left
LCURSORS_36 = $(LCURSORS_24:.24.left=.36.left)
LCURSORS_48 = $(LCURSORS_24:.24.left=.48.left)
LCURSORS_60 = $(LCURSORS_24:.24.left=.60.left)
LCURSORS_72 = $(LCURSORS_24:.24.left=.72.left)
LCURSORS = $(LCURSORS_24:.24.left=.left)
LPNG_24 = $(LCURSORS_24:.24.left=.24.left.png)
LPNG_36 = $(LCURSORS_24:.24.left=.36.left.png)
LPNG_48 = $(LCURSORS_24:.24.left=.48.left.png)
LPNG_60 = $(LCURSORS_24:.24.left=.60.left.png)
LPNG_72 = $(LCURSORS_24:.24.left=.72.left.png)
WINCURSORS = default.cur help.cur progress.cur wait.cur text.cur crosshair.cur pencil.cur \
ns-resize.cur ew-resize.cur nesw-resize.cur nwse-resize.cur up_arrow.cur pointer.cur move.cur \
n-resize.cur s-resize.cur e-resize.cur w-resize.cur ne-resize.cur nw-resize.cur se-resize.cur sw-resize.cur \
not-allowed.cur
WINCURSORS_LARGE = $(WINCURSORS:.cur=_large.cur)
LWINCURSORS = default_left.cur help_left.cur progress_left.cur pencil_left.cur pointer_left.cur
LWINCURSORS_LARGE = $(LWINCURSORS:_left.cur=_large_left.cur)
THEME_NAME = Hackneyed
THEME_NAME_24 = $(THEME_NAME)-24x24
THEME_NAME_36 = $(THEME_NAME)-36x36
THEME_NAME_48 = $(THEME_NAME)-48x48
THEME_COMMENT = Windows 3.x-inspired cursors
THEME_EXAMPLE = default
VERSION = 0.6
SIZES ?= 24,36,48,60,72
PREVIEW_SIZE = 48
XCURSORGEN = xcursorgen
.DEFAULT_GOAL = all-dist
PREFIX ?= /usr/local
WAIT_FRAMES=28
WAIT_DEFAULT_FRAMETIME=35
WAIT_CUSTOM_FRAMETIMES=frame_11_time=650

all-sizes: all.24 all.36 all.48 all.24.left all.36.left all.48.left all.left all
all-themes: theme.24 theme.24.left theme.36 theme.36.left theme.36 theme.36.left theme.left theme
all-dist: dist.left dist.24 dist.36 dist.36 dist.24.left dist.36.left dist.36.left pack dist

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
	zip -r Hackneyed-Windows.zip Hackneyed-Windows

dist: theme
	tar -jcof $(THEME_NAME)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME)

dist.left: theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME)

dist.24: theme.24
	tar -jcof $(THEME_NAME_32)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_32)

dist.36: theme.36
	tar -jcof $(THEME_NAME_48)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_48)

dist.48: theme.64
	tar -jcof $(THEME_NAME_64)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_64)

dist.24.left: theme.24.left
	tar -jcof $(THEME_NAME_32)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_32)

dist.36.left: theme.36.left
	tar -jcof $(THEME_NAME_48)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_48)

dist.48.left: theme.36.left
	tar -jcof $(THEME_NAME_64)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_64)

theme: all
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/multi-sized/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME)/index.theme
	./do-symlinks.sh $(THEME_NAME)/cursors

theme.left: all.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/left-handed, multi-sized/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME)/index.theme
	./do-symlinks.sh L$(THEME_NAME)/cursors

theme.24: all.24
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/24x24/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_24)/index.theme
	./do-symlinks.sh $(THEME_NAME_24)/cursors

theme.36: all.36
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/36x36/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_36)/index.theme
	./do-symlinks.sh $(THEME_NAME_36)/cursors

theme.48: all.48
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/64x64/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_48)/index.theme
	./do-symlinks.sh $(THEME_NAME_48)/cursors

theme.24.left: all.24.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/24x24, left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_24)/index.theme
	./do-symlinks.sh L$(THEME_NAME_24)/cursors

theme.36.left: all.36.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/36x36, left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_36)/index.theme
	./do-symlinks.sh L$(THEME_NAME_36)/cursors

theme.48.left: all.48.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/48x48, left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_48)/index.theme
	./do-symlinks.sh L$(THEME_NAME_48)/cursors

all: $(CURSORS)
	rm -rf $(THEME_NAME)
	mkdir -p $(THEME_NAME)/cursors
	cp $(CURSORS) $(THEME_NAME)/cursors
#	echo \(trim-cursor-files "\"$(THEME_NAME)/cursors/*\""\)|cat trim-cursor-files.scm - |gimp -i -b -

all.left: $(CURSORS) $(LCURSORS)
	rm -rf L$(THEME_NAME)
	mkdir -p L$(THEME_NAME)/cursors
	cp $(CURSORS) L$(THEME_NAME)/cursors
	for l in $(LCURSORS); do \
		cp $$l L$(THEME_NAME)/cursors/$${l/.left/}; \
	done
#	echo \(trim-cursor-files "\"L$(THEME_NAME)/cursors/*\""\)|cat trim-cursor-files.scm - |gimp -i -b -

all.24: $(CURSORS_24)
	rm -rf $(THEME_NAME_24)
	mkdir -p $(THEME_NAME_24)/cursors
	for l in $(CURSORS_24); do \
		cp $$l $(THEME_NAME_24)/cursors/$${l/.24/}; \
	done

all.36: $(CURSORS_36)
	rm -rf $(THEME_NAME_36)
	mkdir -p $(THEME_NAME_36)/cursors
	for l in $(CURSORS_36); do \
		cp $$l $(THEME_NAME_36)/cursors/$${l/.36/}; \
	done

all.48: $(CURSORS_48)
	rm -rf $(THEME_NAME_48)
	mkdir -p $(THEME_NAME_48)/cursors
	for l in $(CURSORS_48); do \
		cp $$l $(THEME_NAME_48)/cursors/$${l/48/}; \
	done

all.24.left: $(CURSORS_24) $(LCURSORS_24)
	rm -rf L$(THEME_NAME_24)
	mkdir -p L$(THEME_NAME_24)/cursors
	for l in $(CURSORS_24); do \
		cp $$l L$(THEME_NAME_24)/cursors/$${l/.24/}; \
	done
	for l in $(LCURSORS_24); do \
		cp $$l L$(THEME_NAME_24)/cursors/$${l/.24.left/}; \
	done

all.36.left: $(CURSORS_36) $(LCURSORS_36)
	rm -rf L$(THEME_NAME_36)
	mkdir -p L$(THEME_NAME_36)/cursors
	for l in $(CURSORS_36); do \
		cp $$l L$(THEME_NAME_36)/cursors/$${l/.36/}; \
	done
	for l in $(LCURSORS_36); do \
		cp $$l L$(THEME_NAME_36)/cursors/$${l/.36.left/}; \
	done

all.48.left: $(CURSORS_48) $(LCURSORS_48)
	rm -rf L$(THEME_NAME_48)
	mkdir -p L$(THEME_NAME_48)/cursors
	for l in $(CURSORS_48); do \
		cp $$l L$(THEME_NAME_48)/cursors/$${l/.48/}; \
	done
	for l in $(LCURSORS_48); do \
		cp $$l L$(THEME_NAME_48)/cursors/$${l/.48.left/}; \
	done

%.in: hotspots/*/%.in
	cat hotspots/{$(SIZES)}/$@ > $@

%_left.in: hotspots/*/%_left.in
	cat hotspots/{$(SIZES)}/$@ > $@

%.png: $(RSVG_SOURCE)
	@{\
		target=$$(cut -d. -f1 <<< $@); \
		size=$$(cut -d. -f2 <<< $@); \
		dpi=$$(((96 * $$size) / 24)); \
		echo "$${target} ($@): $${size}px, $${dpi} DPI"; \
		inkscape --without-gui -i $${target} -d $$dpi -f $< -e $@ >/dev/null; \
	}

%.left.png: $(LSVG_SOURCE)
	@{\
		target=$$(cut -d. -f1 <<< $@); \
		size=$$(cut -d. -f2 <<< $@); \
		dpi=$$(((96 * $$size) / 24)); \
		echo "$${target} ($@): $${size}px, $${dpi} DPI"; \
		inkscape --without-gui -i $${target} -d $$dpi -f $< -e $@ >/dev/null; \
	}

%: %.in %.24.png %.36.png %.48.png %.60.png %.72.png
	$(XCURSORGEN) $< $@

%.left: %_left.in %.24.left.png %.36.left.png %.48.left.png %.60.left.png %.72.left.png
	$(XCURSORGEN) $< $@

%.24: hotspots/24/%.in %.24.png
	$(XCURSORGEN) $< $@

%.36: hotspots/36/%.in %.36.png
	$(XCURSORGEN) $< $@

%.48: hotspots/48/%.in %.48.png
	$(XCURSORGEN) $< $@

%.24.left: hotspots/24/%_left.in %.24.left.png
	$(XCURSORGEN) $< $@

%.36.left: hotspots/36/%_left.in %.36.left.png
	$(XCURSORGEN) $< $@

%.48.left: hotspots/48/%_left.in %.48.left.png
	$(XCURSORGEN) $< $@

ico2cur: ico2cur.c
	$(CC) -std=c99 -Wall -Werror -pedantic -g -o ico2cur ico2cur.c

%_large_left.png: $(WSVG_SOURCE)
	inkscape --without-gui -i $(@:.png=) -f $< -e $@ >/dev/null

%_large.png: $(WSVG_SOURCE)
	inkscape --without-gui -i $(@:.png=) -f $< -e $@ >/dev/null

%_large_left.ico: %_large_left.png
	convert $< $@

%_large.ico: %_large.png
	convert $< $@

%.ico: %.24.png
	convert $< $@

%_left.ico: %.24.left.png
	convert $< $@

%.cur: %.ico hotspots/32/%.in ico2cur
	@{\
		set -- $$(cat hotspots/32/$(@:.cur=.in)); \
		./ico2cur -x $$2 -y $$3 $<; \
	}

%_large.cur: %_large.ico hotspots/wc-large ico2cur
	./ico2cur -p hotspots/wc-large $<

%_large_left.cur: %_large_left.ico hotspots/wc-large ico2cur
	./ico2cur -p hotspots/wc-large $<

wait.24.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=24 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.36.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=36 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.48.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=48 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.60.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=60 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.72.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=72 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.24: wait.24.in
	$(XCURSORGEN) $< $@

wait.36: wait.36.in
	$(XCURSORGEN) $< $@

wait.48: wait.48.in
	$(XCURSORGEN) $< $@

wait: wait.24.in wait.36.in wait.48.in wait.60.in wait.72.in
	cat wait.*.in|$(XCURSORGEN) - $@

preview: $(PNG_$(PREVIEW_SIZE)) $(LPNG_$(PREVIEW_SIZE))
	montage -background none -gravity center -geometry +10+10 -mode concatenate -tile 9x10 \
		{default,help,progress,alias,copy,context-menu,no-drop,dnd-move,center_ptr}.$(PREVIEW_SIZE).png \
		{help,progress,alias,copy,context-menu,no-drop,dnd-move,default,right_ptr}.$(PREVIEW_SIZE).left.png \
		{wait,openhand,pointer,closedhand,sw-resize,se-resize,w-resize,e-resize}.$(PREVIEW_SIZE).png \
		{n-resize,s-resize,nw-resize,ne-resize,split_v,zoom,zoom-in,zoom-out,nesw-resize}.$(PREVIEW_SIZE).png \
		{nwse-resize,ew-resize,ns-resize,split_h}.$(PREVIEW_SIZE).png \
		{text,vertical-text,move,crosshair,plus,not-allowed}.$(PREVIEW_SIZE).png \
		{pirate,X_cursor,wayland-cursor,draft,pencil,color-picker}.$(PREVIEW_SIZE).png \
		{up_arrow,right_arrow,left_arrow}.$(PREVIEW_SIZE).png \
		preview.png

clean:
	rm -rf Hackneyed-Windows $(THEME_NAME) L$(THEME_NAME) $(THEME_NAME_32) $(THEME_NAME_48) $(THEME_NAME_64) L$(THEME_NAME_32) L$(THEME_NAME_48) L$(THEME_NAME_64)
	rm -f $(CURSORS) $(CURSORS_32) $(CURSORS_48) $(CURSORS_64) $(LCURSORS) $(LCURSORS_32) $(LCURSORS_48) $(LCURSORS_64)
	rm -f $(PNG_32) $(PNG_40) $(PNG_48) $(PNG_56) $(PNG_64)
	rm -f $(LPNG_32) $(LPNG_40) $(LPNG_48) $(LPNG_56) $(LPNG_64)
	rm -f $(WINCURSORS) $(WINCURSORS_LARGE) $(LWINCURSORS) $(LWINCURSORS_LARGE)
	rm -f *.in ico2cur
	rm -f wait*.png

.PHONY: all all-dist all.left all.24 all.36 all.48 all.24.left all.36.left all.48.left clean dist dist.left \
dist.24 dist.36 dist.48 dist.24.left dist.36.left dist.48.left install pack preview source-dist theme theme.left \
theme.24 theme.36 theme.48 theme.24.left theme.36.left theme.48.left windows-cursors all-sizes all-themes
.SUFFIXES:
.PRECIOUS: %.in %_left.in %.png %.left.png
.DELETE_ON_ERROR:
