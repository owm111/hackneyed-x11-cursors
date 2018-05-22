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
VERSION = 0.6
RSVG_SOURCE = src/theme-main.svg
LSVG_SOURCE = src/theme-left.svg
SIZE_SMALL=24
SIZE_MEDIUM=36
SIZE_LARGE=48
SIZE_LARGE1=60
SIZE_LARGE2=72
CURSORS_SMALL = default.$(SIZE_SMALL) \
	text.$(SIZE_SMALL) \
	pointer.$(SIZE_SMALL) \
	help.$(SIZE_SMALL) \
	progress.$(SIZE_SMALL) \
	wait.$(SIZE_SMALL) \
	copy.$(SIZE_SMALL) \
	alias.$(SIZE_SMALL) \
	no-drop.$(SIZE_SMALL) \
	not-allowed.$(SIZE_SMALL) \
	split_v.$(SIZE_SMALL) \
	split_h.$(SIZE_SMALL) \
	e-resize.$(SIZE_SMALL) \
	ne-resize.$(SIZE_SMALL) \
	nw-resize.$(SIZE_SMALL) \
	n-resize.$(SIZE_SMALL) \
	se-resize.$(SIZE_SMALL) \
	sw-resize.$(SIZE_SMALL) \
	s-resize.$(SIZE_SMALL) \
	w-resize.$(SIZE_SMALL) \
	vertical-text.$(SIZE_SMALL) \
	crosshair.$(SIZE_SMALL) \
	up_arrow.$(SIZE_SMALL) \
	context-menu.$(SIZE_SMALL) \
	ew-resize.$(SIZE_SMALL) \
	ns-resize.$(SIZE_SMALL) \
	nesw-resize.$(SIZE_SMALL) \
	nwse-resize.$(SIZE_SMALL) \
	pencil.$(SIZE_SMALL) \
	right_ptr.$(SIZE_SMALL) \
	zoom.$(SIZE_SMALL) \
	zoom-in.$(SIZE_SMALL) \
	zoom-out.$(SIZE_SMALL) \
	pirate.$(SIZE_SMALL) \
	X_cursor.$(SIZE_SMALL) \
	closedhand.$(SIZE_SMALL) \
	openhand.$(SIZE_SMALL) \
	color-picker.$(SIZE_SMALL) \
	plus.$(SIZE_SMALL) \
	center_ptr.$(SIZE_SMALL) \
	move.$(SIZE_SMALL) \
	all-scroll.$(SIZE_SMALL) \
	dnd-move.$(SIZE_SMALL) \
	wayland-cursor.$(SIZE_SMALL) \
	down_arrow.$(SIZE_SMALL) \
	draft.$(SIZE_SMALL) \
	left_arrow.$(SIZE_SMALL) \
	right_arrow.$(SIZE_SMALL) \
	exchange.$(SIZE_SMALL) \
	ul_angle.$(SIZE_SMALL) \
	ur_angle.$(SIZE_SMALL) \
	ll_angle.$(SIZE_SMALL) \
	lr_angle.$(SIZE_SMALL) \
	based_arrow_down.$(SIZE_SMALL) \
	based_arrow_up.$(SIZE_SMALL) \
	top_tee.$(SIZE_SMALL) \
	bottom_tee.$(SIZE_SMALL) \
	left_tee.$(SIZE_SMALL) \
	right_tee.$(SIZE_SMALL) \
	draped_box.$(SIZE_SMALL)\
	coffee_mug.$(SIZE_SMALL)
CURSORS_MEDIUM = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_MEDIUM))
CURSORS_LARGE = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE))
CURSORS_LARGE1 = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE1))
CURSORS_LARGE2 = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE2))
CURSORS = $(CURSORS_SMALL:.$(SIZE_SMALL)=)
PNG_SMALL = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_SMALL).png)
PNG_MEDIUM = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_MEDIUM).png)
PNG_LARGE = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE).png)
PNG_LARGE1 = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE1).png)
PNG_LARGE2 = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE1).png)
LCURSORS_SMALL = alias.$(SIZE_SMALL).left \
	color-picker.$(SIZE_SMALL).left \
	context-menu.$(SIZE_SMALL).left \
	copy.$(SIZE_SMALL).left \
	default.$(SIZE_SMALL).left \
	help.$(SIZE_SMALL).left \
	pencil.$(SIZE_SMALL).left \
	dnd-move.$(SIZE_SMALL).left \
	zoom-in.$(SIZE_SMALL).left \
	zoom.$(SIZE_SMALL).left \
	zoom-out.$(SIZE_SMALL).left \
	progress.$(SIZE_SMALL).left \
	no-drop.$(SIZE_SMALL).left \
	draft.$(SIZE_SMALL).left \
	right_ptr.$(SIZE_SMALL).left \
	openhand.$(SIZE_SMALL).left \
	closedhand.$(SIZE_SMALL).left \
	pointer.$(SIZE_SMALL).left \
	coffee_mug.$(SIZE_SMALL).left \
	exchange.$(SIZE_SMALL).left
LCURSORS_MEDIUM = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_MEDIUM).left)
LCURSORS_LARGE = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_LARGE).left)
LCURSORS_LARGE1 = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_LARGE1).left)
LCURSORS_LARGE2 = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_LARGE2).left)
LCURSORS = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.left)
LPNG_SMALL = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_SMALL).left.png)
LPNG_MEDIUM = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_MEDIUM).left.png)
LPNG_LARGE = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_LARGE).left.png)
LPNG_LARGE1 = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_LARGE1).left.png)
LPNG_LARGE2 = $(LCURSORS_SMALL:.$(SIZE_SMALL).left=.$(SIZE_LARGE2).left.png)
WINCURSORS = default.cur help.cur progress.cur wait.cur text.cur crosshair.cur pencil.cur \
ns-resize.cur ew-resize.cur nesw-resize.cur nwse-resize.cur up_arrow.cur pointer.cur move.cur \
n-resize.cur s-resize.cur e-resize.cur w-resize.cur ne-resize.cur nw-resize.cur se-resize.cur sw-resize.cur \
not-allowed.cur
WINCURSORS_LARGE = $(WINCURSORS:.cur=_large.cur)
LWINCURSORS = default_left.cur help_left.cur progress_left.cur pencil_left.cur pointer_left.cur
LWINCURSORS_LARGE = $(LWINCURSORS:_left.cur=_large_left.cur)
THEME_NAME = Hackneyed
THEME_NAME_SMALL = $(THEME_NAME)-$(SIZE_SMALL)x$(SIZE_SMALL)
THEME_NAME_MEDIUM = $(THEME_NAME)-$(SIZE_MEDIUM)x$(SIZE_MEDIUM)
THEME_NAME_LARGE = $(THEME_NAME)-$(SIZE_LARGE)x$(SIZE_LARGE)
THEME_COMMENT = Windows 3.x-inspired cursors
THEME_EXAMPLE = default
THEME_WINDOWS = $(THEME_NAME)-Windows-$(VERSION)
SIZES ?= $(SIZE_SMALL),$(SIZE_MEDIUM),$(SIZE_LARGE),$(SIZE_LARGE1),$(SIZE_LARGE2)
PREVIEW_SIZE = $(SIZE_MEDIUM)
XCURSORGEN = xcursorgen
.DEFAULT_GOAL = all-dist
PREFIX ?= /usr/local
WAIT_FRAMES=28
WAIT_DEFAULT_FRAMETIME=35
WAIT_CUSTOM_FRAMETIMES=frame_11_time=650

all-sizes: all.small all.medium all.large all.small.left all.medium.left all.large.left all.left all
all-themes: theme theme.left theme.small theme.medium theme.large theme.small.left theme.medium.left theme.large.left
all-dist: dist.left dist.small dist.medium dist.large dist.small.left dist.medium.left dist.large.left pack dist

install: theme theme.left
	test -e $(DESTDIR)$(PREFIX)/share/icons || install -d -m755 $(DESTDIR)$(PREFIX)/share/icons
	cp -a $(THEME_NAME) L$(THEME_NAME) -t $(DESTDIR)$(PREFIX)/share/icons

pack: theme theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-pack.tar.bz2 $(THEME_NAME) L$(THEME_NAME)

source-dist:
	git archive --format=tar.gz --prefix=hackneyed-x11-cursors-$(VERSION)/ HEAD > \
		hackneyed-x11-cursors-$(VERSION).tar.gz

windows-cursors: $(WINCURSORS) $(WINCURSORS_LARGE) $(LWINCURSORS) $(LWINCURSORS_LARGE)
	rm -rf $(THEME_WINDOWS)
	mkdir -p $(THEME_WINDOWS)/{King-size,Standard}
	cp $(WINCURSORS_LARGE) $(LWINCURSORS_LARGE) $(THEME_WINDOWS)/King-size
	cp $(WINCURSORS) $(LWINCURSORS) $(THEME_WINDOWS)/Standard
	zip -r $(THEME_WINDOWS).zip $(THEME_WINDOWS)

dist: theme
	tar -jcof $(THEME_NAME)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME)

dist.left: theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME)

dist.small: theme.small
	tar -jcof $(THEME_NAME_SMALL)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_SMALL)

dist.medium: theme.medium
	tar -jcof $(THEME_NAME_MEDIUM)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_MEDIUM)

dist.large: theme.large
	tar -jcof $(THEME_NAME_LARGE)-$(VERSION)-right-handed.tar.bz2 $(THEME_NAME_LARGE)

dist.small.left: theme.small.left
	tar -jcof $(THEME_NAME_SMALL)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_SMALL)

dist.medium.left: theme.medium.left
	tar -jcof $(THEME_NAME_LARGE)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_MEDIUM)

dist.large.left: theme.large.left
	tar -jcof $(THEME_NAME_LARGE)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_LARGE)

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

theme.small: all.small
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/$(SIZE_SMALL)x$(SIZE_SMALL)/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_SMALL)/index.theme
	./do-symlinks.sh $(THEME_NAME_SMALL)/cursors

theme.medium: all.medium
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/$(SIZE_MEDIUM)x$(SIZE_MEDIUM)/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_MEDIUM)/index.theme
	./do-symlinks.sh $(THEME_NAME_MEDIUM)/cursors

theme.large: all.large
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/$(SIZE_LARGE)x$(SIZE_LARGE)/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME_LARGE)/index.theme
	./do-symlinks.sh $(THEME_NAME_LARGE)/cursors

theme.small.left: all.small.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/$(SIZE_SMALL)x$(SIZE_SMALL), left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_SMALL)/index.theme
	./do-symlinks.sh L$(THEME_NAME_SMALL)/cursors

theme.medium.left: all.medium.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/$(SIZE_MEDIUM)x$(SIZE_MEDIUM), left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_MEDIUM)/index.theme
	./do-symlinks.sh L$(THEME_NAME_MEDIUM)/cursors

theme.large.left: all.large.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/$(SIZE_LARGE)x$(SIZE_LARGE), left-handed/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > L$(THEME_NAME_LARGE)/index.theme
	./do-symlinks.sh L$(THEME_NAME_LARGE)/cursors

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

all.small: $(CURSORS_SMALL)
	rm -rf $(THEME_NAME_SMALL)
	mkdir -p $(THEME_NAME_SMALL)/cursors
	for l in $(CURSORS_SMALL); do \
		cp $$l $(THEME_NAME_SMALL)/cursors/$${l/.$(SIZE_SMALL)/}; \
	done

all.medium: $(CURSORS_MEDIUM)
	rm -rf $(THEME_NAME_MEDIUM)
	mkdir -p $(THEME_NAME_MEDIUM)/cursors
	for l in $(CURSORS_MEDIUM); do \
		cp $$l $(THEME_NAME_MEDIUM)/cursors/$${l/.$(SIZE_MEDIUM)/}; \
	done

all.large: $(CURSORS_LARGE)
	rm -rf $(THEME_NAME_LARGE)
	mkdir -p $(THEME_NAME_LARGE)/cursors
	for l in $(CURSORS_LARGE); do \
		cp $$l $(THEME_NAME_LARGE)/cursors/$${l/.$(SIZE_LARGE)/}; \
	done

all.small.left: $(CURSORS_SMALL) $(LCURSORS_SMALL)
	rm -rf L$(THEME_NAME_SMALL)
	mkdir -p L$(THEME_NAME_SMALL)/cursors
	for l in $(CURSORS_SMALL); do \
		cp $$l L$(THEME_NAME_SMALL)/cursors/$${l/.$(SIZE_SMALL)/}; \
	done
	for l in $(LCURSORS_SMALL); do \
		cp $$l L$(THEME_NAME_SMALL)/cursors/$${l/.$(SIZE_SMALL).left/}; \
	done

all.medium.left: $(CURSORS_MEDIUM) $(LCURSORS_MEDIUM)
	rm -rf L$(THEME_NAME_MEDIUM)
	mkdir -p L$(THEME_NAME_MEDIUM)/cursors
	for l in $(CURSORS_MEDIUM); do \
		cp $$l L$(THEME_NAME_MEDIUM)/cursors/$${l/.$(SIZE_MEDIUM)/}; \
	done
	for l in $(LCURSORS_MEDIUM); do \
		cp $$l L$(THEME_NAME_MEDIUM)/cursors/$${l/.$(SIZE_MEDIUM).left/}; \
	done

all.large.left: $(CURSORS_LARGE) $(LCURSORS_LARGE)
	rm -rf L$(THEME_NAME_LARGE)
	mkdir -p L$(THEME_NAME_LARGE)/cursors
	for l in $(CURSORS_LARGE); do \
		cp $$l L$(THEME_NAME_LARGE)/cursors/$${l/.$(SIZE_LARGE)/}; \
	done
	for l in $(LCURSORS_LARGE); do \
		cp $$l L$(THEME_NAME_LARGE)/cursors/$${l/.$(SIZE_LARGE).left/}; \
	done

%.in: hotspots/*/%.in
	cat hotspots/{$(SIZES)}/$@ > $@

%_left.in: hotspots/*/%_left.in
	cat hotspots/{$(SIZES)}/$@ > $@

%.png: $(RSVG_SOURCE)
	@{\
		target=$$(cut -d. -f1 <<< $@); \
		size=$$(cut -d. -f2 <<< $@); \
		dpi=$$(((96 * $$size) / $(SIZE_SMALL))); \
		echo "$${target} ($@): $${size}px, $${dpi} DPI"; \
		inkscape --without-gui -i $${target} -d $$dpi -f $< -e $@ >/dev/null; \
	}

%.left.png: $(LSVG_SOURCE)
	@{\
		target=$$(cut -d. -f1 <<< $@); \
		size=$$(cut -d. -f2 <<< $@); \
		dpi=$$(((96 * $$size) / $(SIZE_SMALL))); \
		echo "$${target} ($@): $${size}px, $${dpi} DPI"; \
		inkscape --without-gui -i $${target} -d $$dpi -f $< -e $@ >/dev/null; \
	}

%: %.in %.$(SIZE_SMALL).png %.$(SIZE_MEDIUM).png %.$(SIZE_LARGE).png %.$(SIZE_LARGE1).png %.$(SIZE_LARGE2).png
	$(XCURSORGEN) $< $@

%.left: %_left.in %.$(SIZE_SMALL).left.png %.$(SIZE_MEDIUM).left.png %.$(SIZE_LARGE).left.png %.$(SIZE_LARGE1).left.png %.$(SIZE_LARGE2).left.png
	$(XCURSORGEN) $< $@

%.$(SIZE_SMALL): hotspots/$(SIZE_SMALL)/%.in %.$(SIZE_SMALL).png
	$(XCURSORGEN) $< $@

%.$(SIZE_MEDIUM): hotspots/$(SIZE_MEDIUM)/%.in %.$(SIZE_MEDIUM).png
	$(XCURSORGEN) $< $@

%.$(SIZE_LARGE): hotspots/$(SIZE_LARGE)/%.in %.$(SIZE_LARGE).png
	$(XCURSORGEN) $< $@

%.$(SIZE_SMALL).left: hotspots/$(SIZE_SMALL)/%_left.in %.$(SIZE_SMALL).left.png
	$(XCURSORGEN) $< $@

%.$(SIZE_MEDIUM).left: hotspots/$(SIZE_MEDIUM)/%_left.in %.$(SIZE_MEDIUM).left.png
	$(XCURSORGEN) $< $@

%.$(SIZE_LARGE).left: hotspots/$(SIZE_LARGE)/%_left.in %.$(SIZE_LARGE).left.png
	$(XCURSORGEN) $< $@

ico2cur: ico2cur.c
	$(CC) -std=c99 -Wall -Werror -pedantic -g -o ico2cur ico2cur.c

# harcoding this is no problem, Windows cannot make use of larger cursors anyway
# (and probably never will)
%_large_left.png: %.32.left.png
	inkscape --without-gui -i $(@:.png=) -f $< -e $@ >/dev/null

%_large.png: %.32.png
	inkscape --without-gui -i $(@:.png=) -f $< -e $@ >/dev/null

%_large_left.ico: %.32.left.png
	convert $< $@

%_large.ico: %.32.png
	convert $< $@

%.ico: %.$(SIZE_SMALL).png
	convert -background none -extent 32x32 $< $@

%_left.ico: %.$(SIZE_SMALL).left.png
	convert -background none -extent 32x32 $< $@

%.cur: %.ico hotspots/$(SIZE_SMALL)/%.in ico2cur
	@{\
		set -- $$(cat hotspots/$(SIZE_SMALL)/$(@:.cur=.in)); \
		./ico2cur -x $$2 -y $$3 $<; \
	}

%_large.cur: %_large.ico ico2cur
	{\
		set -- $$(cat hotspots/$(SIZE_SMALL)/$(@:_large.cur=.in)); \
		x=$$(( (32 * $$2) / ($(SIZE_SMALL) - 1) )); \
		y=$$(( (32 * $$3) / ($(SIZE_SMALL) - 1) )); \
		./ico2cur -x $$x -y $$y $<; \
	}

%_large_left.cur: %_large_left.ico ico2cur
	@{\
		set -- $$(cat hotspots/$(SIZE_SMALL)/$(@:_large_left.cur=_left.in)); \
		x=$$(( (32 * $$2) / ($(SIZE_SMALL) - 1) )); \
		y=$$(( (32 * $$3) / ($(SIZE_SMALL) - 1) )); \
		./ico2cur -x $$x -y $$y $<; \
	}

wait.$(SIZE_SMALL).in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=$(SIZE_SMALL) \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.$(SIZE_MEDIUM).in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=$(SIZE_MEDIUM) \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.$(SIZE_LARGE).in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=$(SIZE_LARGE) \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.$(SIZE_LARGE1).in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=$(SIZE_LARGE1) \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.$(SIZE_LARGE2).in: $(RSVG_SOURCE) make-animated-cursor.sh
	@echo '>>> $@'
	@./make-animated-cursor.sh src=$< target=wait size=$(SIZE_LARGE2) \
	default_frametime=$(WAIT_DEFAULT_FRAMETIME) $(WAIT_CUSTOM_FRAMETIMES) \
	frames=$(WAIT_FRAMES)

wait.$(SIZE_SMALL): wait.$(SIZE_SMALL).in
	$(XCURSORGEN) $< $@

wait.$(SIZE_MEDIUM): wait.$(SIZE_MEDIUM).in
	$(XCURSORGEN) $< $@

wait.$(SIZE_LARGE): wait.$(SIZE_LARGE).in
	$(XCURSORGEN) $< $@

wait: wait.$(SIZE_SMALL).in wait.$(SIZE_MEDIUM).in wait.$(SIZE_LARGE).in wait.$(SIZE_LARGE1).in wait.$(SIZE_LARGE2).in
	cat wait.*.in|$(XCURSORGEN) - $@

preview: $(PNG_$(PREVIEW_SIZE)) $(LPNG_$(PREVIEW_SIZE)) wait.$(PREVIEW_SIZE).png
	montage -background none -mode concatenate -tile 9x6 -geometry +10+5 \
		{default,help,progress,alias,copy,context-menu,no-drop,dnd-move,center_ptr}.$(PREVIEW_SIZE).png \
		{help,progress,alias,copy,context-menu,no-drop,dnd-move,default,right_ptr}.$(PREVIEW_SIZE).left.png \
		{wait,openhand,pointer,closedhand,sw-resize,se-resize,w-resize,e-resize}.$(PREVIEW_SIZE).png \
		{n-resize,s-resize,nw-resize,ne-resize,split_v,zoom,zoom-in,zoom-out,nesw-resize}.$(PREVIEW_SIZE).png \
		{nwse-resize,ew-resize,ns-resize,split_h}.$(PREVIEW_SIZE).png \
		{text,vertical-text,move,crosshair,plus,not-allowed}.$(PREVIEW_SIZE).png \
		{pirate,X_cursor,wayland-cursor,draft,pencil,color-picker}.$(PREVIEW_SIZE).png \
		{up_arrow,right_arrow,left_arrow}.$(PREVIEW_SIZE).png \
		preview.png
	montage -background none -mode concatenate -tile 3x2 -geometry +5+5 \
	{default,help,progress,wait,pointer,pencil}.$(PREVIEW_SIZE).png preview-small.png

clean:
	rm -rf $(THEME_WINDOWS) $(THEME_NAME) L$(THEME_NAME) $(THEME_NAME_SMALL) $(THEME_NAME_MEDIUM) $(THEME_NAME_LARGE) L$(THEME_NAME_SMALL) L$(THEME_NAME_MEDIUM) L$(THEME_NAME_LARGE)
	rm -f $(CURSORS) $(CURSORS_SMALL) $(CURSORS_MEDIUM) $(CURSORS_LARGE) $(LCURSORS) $(LCURSORS_SMALL) $(LCURSORS_MEDIUM) $(LCURSORS_LARGE)
	rm -f $(PNG_SMALL) $(PNG_MEDIUM) $(PNG_LARGE) $(PNG_LARGE1) $(PNG_LARGE2)
	rm -f $(LPNG_SMALL) $(LPNG_MEDIUM) $(LPNG_LARGE) $(LPNG_LARGE1) $(LPNG_LARGE2)
	rm -f $(WINCURSORS) $(WINCURSORS_LARGE) $(LWINCURSORS) $(LWINCURSORS_LARGE)
	rm -f *.in ico2cur
	rm -f wait*.png

.PHONY: all all-dist all.left all.small all.medium all.large all.small.left all.medium.left all.large.left \
	clean dist dist.left dist.small dist.medium dist.large dist.small.left dist.medium.left dist.large.left \
	install pack preview source-dist theme theme.left theme.small theme.medium theme.large theme.small.left \
	theme.medium.left theme.large.left windows-cursors all-sizes all-themes
.SUFFIXES:
.PRECIOUS: %.in %_left.in %.png %.left.png %_left.ico %.ico %_large.ico %_large_left.ico
.DELETE_ON_ERROR:
