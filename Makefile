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
RSVG_SOURCE = src/theme-right.svg
LSVG_SOURCE = src/theme-left.svg
WSVG_SOURCE = src/wc-large.svg
CURSORS_32 = default.32 text.32 pointer.32 help.32 progress.32 wait.32 copy.32 alias.32 no-drop.32 \
not-allowed.32 split_v.32 split_h.32 e-resize.32 ne-resize.32 nw-resize.32 n-resize.32 se-resize.32 \
sw-resize.32 s-resize.32 w-resize.32 vertical-text.32 crosshair.32 up_arrow.32 \
context-menu.32 ew-resize.32 ns-resize.32 nesw-resize.32 nwse-resize.32 pencil.32 right_ptr.32 \
zoom.32 zoom-in.32 zoom-out.32 pirate.32 X_cursor.32 closedhand.32 openhand.32 color-picker.32 plus.32 \
center_ptr.32 move.32 all-scroll.32 dnd-move.32 wayland-cursor.32 down_arrow.32 draft.32 \
left_arrow.32 right_arrow.32 exchange.32 ul_angle.32 ur_angle.32 ll_angle.32 lr_angle.32 \
based_arrow_down.32 based_arrow_up.32 top_tee.32 bottom_tee.32 left_tee.32 right_tee.32 \
draped_box.32 coffee_mug.32
CURSORS_40 = $(CURSORS_32:.32=.40)
CURSORS_48 = $(CURSORS_32:.32=.48)
CURSORS_56 = $(CURSORS_32:.32=.56)
CURSORS_64 = $(CURSORS_32:.32=.64)
CURSORS = $(CURSORS_32:.32=)
PNG_32 = $(CURSORS_32:.32=.32.png)
PNG_40 = $(CURSORS_32:.32=.40.png)
PNG_48 = $(CURSORS_32:.32=.48.png)
PNG_56 = $(CURSORS_32:.32=.56.png)
PNG_64 = $(CURSORS_32:.32=.64.png)
LCURSORS_32 = alias.32.left color-picker.32.left context-menu.32.left copy.32.left \
default.32.left help.32.left pencil.32.left dnd-move.32.left zoom-in.32.left zoom.32.left \
zoom-out.32.left progress.32.left no-drop.32.left draft.32.left right_ptr.32.left \
openhand.32.left closedhand.32.left pointer.32.left coffee_mug.32.left exchange.32.left
LCURSORS_40 = $(LCURSORS_32:.32.left=.40.left)
LCURSORS_48 = $(LCURSORS_32:.32.left=.48.left)
LCURSORS_56 = $(LCURSORS_32:.32.left=.56.left)
LCURSORS_64 = $(LCURSORS_32:.32.left=.64.left)
LCURSORS = $(LCURSORS_32:.32.left=.left)
LPNG_32 = $(LCURSORS_32:.32.left=.32.left.png)
LPNG_40 = $(LCURSORS_32:.32.left=.40.left.png)
LPNG_48 = $(LCURSORS_32:.32.left=.48.left.png)
LPNG_56 = $(LCURSORS_32:.32.left=.56.left.png)
LPNG_64 = $(LCURSORS_32:.32.left=.64.left.png)
WINCURSORS = default.cur help.cur progress.cur wait.cur text.cur crosshair.cur pencil.cur \
ns-resize.cur ew-resize.cur nesw-resize.cur nwse-resize.cur up_arrow.cur pointer.cur move.cur \
n-resize.cur s-resize.cur e-resize.cur w-resize.cur ne-resize.cur nw-resize.cur se-resize.cur sw-resize.cur \
not-allowed.cur
WINCURSORS_LARGE = $(WINCURSORS:.cur=_large.cur)
LWINCURSORS = default_left.cur help_left.cur progress_left.cur pencil_left.cur pointer_left.cur
LWINCURSORS_LARGE = $(LWINCURSORS:_left.cur=_large_left.cur)
THEME_NAME = Hackneyed
THEME_NAME_32 = $(THEME_NAME)-32x32
THEME_NAME_48 = $(THEME_NAME)-48x48
THEME_NAME_64 = $(THEME_NAME)-64x64
THEME_COMMENT = Windows 3.x-inspired cursors
THEME_EXAMPLE = default
VERSION = 0.5.3
SIZES ?= 32,40,48,56,64
PREVIEW_SIZE = 48
XCURSORGEN = xcursorgen
.DEFAULT_GOAL = all-dist
PREFIX ?= /usr/local
WAIT_FRAMES=26
WAIT_DEFAULT_FRAMETIME=35
WAIT_CUSTOM_FRAMETIMES=frame_11_time=650

all-dist: pack dist dist.left dist.32 dist.48 dist.64 dist.32.left dist.48.left dist.64.left
all-sizes: all all.32 all.48 all.64 all.32.left all.48.left all.64.left all.left
all-themes: theme theme.32 theme.32.left theme.48 theme.48.left theme.64 theme.64.left theme.left

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

dist.32: theme.32
	tar -jcof $(THEME_NAME_32)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_32)

dist.48: theme.48
	tar -jcof $(THEME_NAME_48)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_48)

dist.64: theme.64
	tar -jcof $(THEME_NAME_64)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_64)

dist.32.left: theme.32.left
	tar -jcof $(THEME_NAME_32)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_32)

dist.48.left: theme.48.left
	tar -jcof $(THEME_NAME_48)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_48)

dist.64.left: theme.64.left
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

theme.32: all.32
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/32x32/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_32)/index.theme
	./do-symlinks.sh $(THEME_NAME_32)/cursors

theme.48: all.48
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/48x48/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_48)/index.theme
	./do-symlinks.sh $(THEME_NAME_48)/cursors

theme.64: all.64
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/64x64/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_64)/index.theme
	./do-symlinks.sh $(THEME_NAME_64)/cursors

theme.32.left: all.32.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/32x32, left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_32)/index.theme
	./do-symlinks.sh L$(THEME_NAME_32)/cursors

theme.48.left: all.48.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/48x48, left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_48)/index.theme
	./do-symlinks.sh L$(THEME_NAME_48)/cursors

theme.64.left: all.64.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/64x64, left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_64)/index.theme
	./do-symlinks.sh L$(THEME_NAME_64)/cursors

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

all.32: $(CURSORS_32)
	rm -rf $(THEME_NAME_32)
	mkdir -p $(THEME_NAME_32)/cursors
	for l in $(CURSORS_32); do \
		cp $$l $(THEME_NAME_32)/cursors/$${l/.32/}; \
	done

all.48: $(CURSORS_48)
	rm -rf $(THEME_NAME_48)
	mkdir -p $(THEME_NAME_48)/cursors
	for l in $(CURSORS_48); do \
		cp $$l $(THEME_NAME_48)/cursors/$${l/.48/}; \
	done

all.64: $(CURSORS_64)
	rm -rf $(THEME_NAME_64)
	mkdir -p $(THEME_NAME_64)/cursors
	cp $(CURSORS_64) $(THEME_NAME_64)/cursors
	for l in $(CURSORS_64); do \
		cp $$l $(THEME_NAME_64)/cursors/$${l/.64/}; \
	done

all.32.left: $(CURSORS_32) $(LCURSORS_32)
	rm -rf L$(THEME_NAME_32)
	mkdir -p L$(THEME_NAME_32)/cursors
	cp $(CURSORS_32) L$(THEME_NAME_32)/cursors
	for l in $(CURSORS_32); do \
		cp $$l L$(THEME_NAME_32)/cursors/$${l/.32/}; \
	done
	for l in $(LCURSORS_32); do \
		cp $$l L$(THEME_NAME_32)/cursors/$${l/.32.left/}; \
	done

all.48.left: $(CURSORS_48) $(LCURSORS_48)
	rm -rf L$(THEME_NAME_48)
	mkdir -p L$(THEME_NAME_48)/cursors
	cp $(CURSORS_48) L$(THEME_NAME_48)/cursors
	for l in $(CURSORS_48); do \
		cp $$l L$(THEME_NAME_48)/cursors/$${l/.48/}; \
	done
	for l in $(LCURSORS_48); do \
		cp $$l L$(THEME_NAME_48)/cursors/$${l/.48.left/}; \
	done

all.64.left: $(CURSORS_64) $(LCURSORS_64)
	rm -rf L$(THEME_NAME_64)
	mkdir -p L$(THEME_NAME_64)/cursors
	cp $(CURSORS_64) L$(THEME_NAME_64)/cursors
	for l in $(CURSORS_64); do \
		cp $$l L$(THEME_NAME_64)/cursors/$${l/.64/}; \
	done
	for l in $(LCURSORS_64); do \
		cp $$l L$(THEME_NAME_64)/cursors/$${l/.64.left/}; \
	done

%.in: hotspots/*/%.in
	cat hotspots/{$(SIZES)}/$@ > $@

%_left.in: hotspots/*/%_left.in
	cat hotspots/{$(SIZES)}/$@ > $@

%.png: $(RSVG_SOURCE)
	@{\
		target=$$(cut -d. -f1 <<< $@); \
		size=$$(cut -d. -f2 <<< $@); \
		dpi=$$(((90 * $$size) / 32)); \
		echo "$${target} ($@): $${size}px, $${dpi} DPI"; \
		inkscape --without-gui -i $${target} -d $$dpi -f $< -e $@ >/dev/null; \
	}

%.left.png: $(LSVG_SOURCE)
	@{\
		target=$$(cut -d. -f1 <<< $@); \
		size=$$(cut -d. -f2 <<< $@); \
		dpi=$$(((90 * $$size) / 32)); \
		echo "$${target} ($@): $${size}px, $${dpi} DPI"; \
		inkscape --without-gui -i $${target} -d $$dpi -f $< -e $@ >/dev/null; \
	}

%: %.in %.32.png %.40.png %.48.png %.56.png %.64.png
	$(XCURSORGEN) $< $@

%.left: %_left.in %.32.left.png %.40.left.png %.48.left.png %.56.left.png %.64.left.png
	$(XCURSORGEN) $< $@

%.32: hotspots/32/%.in %.32.png
	$(XCURSORGEN) $< $@

%.48: hotspots/48/%.in %.48.png
	$(XCURSORGEN) $< $@

%.64: hotspots/64/%.in %.64.png
	$(XCURSORGEN) $< $@

%.32.left: hotspots/32/%_left.in %.32.left.png
	$(XCURSORGEN) $< $@

%.48.left: hotspots/48/%_left.in %.48.left.png
	$(XCURSORGEN) $< $@

%.64.left: hotspots/64/%_left.in %.64.left.png
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

%.ico: %.32.png
	convert $< $@

%_left.ico: %.32.left.png
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

wait.32.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=32 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.40.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=40 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.48.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=48 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.56.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=56 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.64.in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=64 \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.32: wait.32.in
	$(XCURSORGEN) $< $@

wait.48: wait.48.in
	$(XCURSORGEN) $< $@

wait.64: wait.64.in
	$(XCURSORGEN) $< $@

wait: wait.32.in wait.40.in wait.48.in wait.56.in wait.64.in
	cat wait.*.in|$(XCURSORGEN) - $@

preview: $(PNG_$(PREVIEW_SIZE)) $(LPNG_$(PREVIEW_SIZE))
	montage -background none -geometry +4+4 -mode concatenate -tile 9x10 \
		{default,help,progress,alias,copy,context-menu,no-drop,dnd-move,center_ptr}.$(PREVIEW_SIZE).png \
		{help,progress,alias,copy,context-menu,no-drop,dnd-move,default,right_ptr}.$(PREVIEW_SIZE).left.png \
		{wait,openhand,pointer,closedhand,sw-resize,se-resize,w-resize,e-resize}.$(PREVIEW_SIZE).png \
		{n-resize,s-resize,nw-resize,ne-resize,split_v,zoom,zoom-in,zoom-out,nesw-resize}.$(PREVIEW_SIZE).png \
		{nwse-resize,ew-resize,ns-resize,split_h}.$(PREVIEW_SIZE).png \
		{text,vertical-text,move,crosshair,plus,not-allowed}.$(PREVIEW_SIZE).png \
		{pirate,X_cursor,wayland-cursor,draft,pencil,color-picker}.$(PREVIEW_SIZE).png \
		{up_arrow,right_arrow,left_arrow}.$(PREVIEW_SIZE).png \
		preview.png
		rm -f wait.48.png

clean:
	rm -rf Hackneyed-Windows $(THEME_NAME) L$(THEME_NAME) $(THEME_NAME_32) $(THEME_NAME_48) $(THEME_NAME_64) L$(THEME_NAME_32) L$(THEME_NAME_48) L$(THEME_NAME_64)
	rm -f $(CURSORS) $(CURSORS_32) $(CURSORS_48) $(CURSORS_64) $(LCURSORS) $(LCURSORS_32) $(LCURSORS_48) $(LCURSORS_64)
	rm -f $(PNG_32) $(PNG_40) $(PNG_48) $(PNG_56) $(PNG_64)
	rm -f $(LPNG_32) $(LPNG_40) $(LPNG_48) $(LPNG_56) $(LPNG_64)
	rm -f $(WINCURSORS) $(WINCURSORS_LARGE) $(LWINCURSORS) $(LWINCURSORS_LARGE)
	rm -f *.in ico2cur

.PHONY: all all-dist all.left all.32 all.48 all.64 all.32.left all.48.left all.64.left clean dist dist.left \
dist.32 dist.48 dist.64 dist.32.left dist.48.left dist.64.left install pack preview source-dist theme theme.left \
theme.32 theme.48 theme.64 theme.32.left theme.48.left theme.64.left windows-cursors all-sizes all-themes
.SUFFIXES:
.PRECIOUS: %.in %_left.in %.png %.left.png
.DELETE_ON_ERROR:
