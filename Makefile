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

VERSION = 0.8
COMMON_SOURCE = theme/common-white.svg
RSVG_SOURCE = theme/right-handed-white.svg
LSVG_SOURCE = theme/left-handed-white.svg
SIZE_SMALL=24
SIZE_MEDIUM=36
SIZE_LARGE=48
SIZE_LARGE1=60
SIZE_LARGE2=72
COMMON_SMALL = text.$(SIZE_SMALL) \
	vertical-text.$(SIZE_SMALL) \
	sb_up_arrow.$(SIZE_SMALL) \
	sb_down_arrow.$(SIZE_SMALL) \
	sb_left_arrow.$(SIZE_SMALL) \
	sb_right_arrow.$(SIZE_SMALL) \
	pirate.$(SIZE_SMALL) \
	based_arrow_up.$(SIZE_SMALL) \
	based_arrow_down.$(SIZE_SMALL) \
	ns-resize.$(SIZE_SMALL) \
	ew-resize.$(SIZE_SMALL) \
	nwse-resize.$(SIZE_SMALL) \
	nesw-resize.$(SIZE_SMALL) \
	move.$(SIZE_SMALL) \
	plus.$(SIZE_SMALL) \
	crosshair.$(SIZE_SMALL) \
	n-resize.$(SIZE_SMALL) \
	s-resize.$(SIZE_SMALL) \
	w-resize.$(SIZE_SMALL) \
	e-resize.$(SIZE_SMALL) \
	nw-resize.$(SIZE_SMALL) \
	ne-resize.$(SIZE_SMALL) \
	sw-resize.$(SIZE_SMALL) \
	se-resize.$(SIZE_SMALL) \
	center_ptr.$(SIZE_SMALL) \
	all-scroll.$(SIZE_SMALL) \
	not-allowed.$(SIZE_SMALL) \
	draped_box.$(SIZE_SMALL) \
	wayland-cursor.$(SIZE_SMALL) \
	X_cursor.$(SIZE_SMALL) \
	ul_angle.$(SIZE_SMALL) \
	ur_angle.$(SIZE_SMALL) \
	ll_angle.$(SIZE_SMALL) \
	lr_angle.$(SIZE_SMALL) \
	split_v.$(SIZE_SMALL) \
	split_h.$(SIZE_SMALL) \
	top_tee.$(SIZE_SMALL) \
	bottom_tee.$(SIZE_SMALL) \
	left_tee.$(SIZE_SMALL) \
	right_tee.$(SIZE_SMALL) \
	wait.$(SIZE_SMALL)
COMMON_MEDIUM=$(COMMON_SMALL:.$(SIZE_SMALL)=.$(SIZE_MEDIUM))
COMMON_LARGE=$(COMMON_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE))
COMMON_LARGE1=$(COMMON_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE1))
COMMON_LARGE2=$(COMMON_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE2))
COMMON_CURSORS=$(COMMON_SMALL:.$(SIZE_SMALL)=)
PNG_COMMON_SMALL=$(COMMON_SMALL:.$(SIZE_SMALL)=.$(SIZE_SMALL).png)
PNG_COMMON_MEDIUM=$(COMMON_MEDIUM:.$(SIZE_MEDIUM)=.$(SIZE_MEDIUM).png)
PNG_COMMON_LARGE=$(COMMON_LARGE:.$(SIZE_LARGE)=.$(SIZE_LARGE).png)
PNG_COMMON_LARGE1=$(COMMON_LARGE1:.$(SIZE_LARGE1)=.$(SIZE_LARGE1).png)
PNG_COMMON_LARGE2=$(COMMON_LARGE2:.$(SIZE_LARGE2)=.$(SIZE_LARGE2).png)
CURSORS_SMALL = alias.$(SIZE_SMALL) \
	color-picker.$(SIZE_SMALL) \
	context-menu.$(SIZE_SMALL) \
	copy.$(SIZE_SMALL) \
	default.$(SIZE_SMALL) \
	help.$(SIZE_SMALL) \
	pencil.$(SIZE_SMALL) \
	dnd-move.$(SIZE_SMALL) \
	zoom.$(SIZE_SMALL) \
	zoom-in.$(SIZE_SMALL) \
	zoom-out.$(SIZE_SMALL) \
	progress.$(SIZE_SMALL) \
	no-drop.$(SIZE_SMALL) \
	draft.$(SIZE_SMALL) \
	right_ptr.$(SIZE_SMALL) \
	openhand.$(SIZE_SMALL) \
	closedhand.$(SIZE_SMALL) \
	pointer.$(SIZE_SMALL) \
	coffee_mug.$(SIZE_SMALL) \
	exchange.$(SIZE_SMALL)
CURSORS_MEDIUM = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_MEDIUM))
CURSORS_LARGE = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE))
CURSORS_LARGE1 = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE1))
CURSORS_LARGE2 = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE2))
CURSORS = $(CURSORS_SMALL:.$(SIZE_SMALL)=)
PNG_SMALL = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_SMALL).png)
PNG_MEDIUM = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_MEDIUM).png)
PNG_LARGE = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE).png)
PNG_LARGE1 = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE1).png)
PNG_LARGE2 = $(CURSORS_SMALL:.$(SIZE_SMALL)=.$(SIZE_LARGE2).png)
LCURSORS_SMALL = alias.$(SIZE_SMALL).left \
	color-picker.$(SIZE_SMALL).left \
	context-menu.$(SIZE_SMALL).left \
	copy.$(SIZE_SMALL).left \
	default.$(SIZE_SMALL).left \
	help.$(SIZE_SMALL).left \
	pencil.$(SIZE_SMALL).left \
	dnd-move.$(SIZE_SMALL).left \
	zoom.$(SIZE_SMALL).left \
	zoom-in.$(SIZE_SMALL).left \
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
WINCURSORS = default.cur help.cur text.cur crosshair.cur pencil.cur \
ns-resize.cur ew-resize.cur nesw-resize.cur nwse-resize.cur sb_up_arrow.cur pointer.cur move.cur \
n-resize.cur s-resize.cur e-resize.cur w-resize.cur ne-resize.cur nw-resize.cur se-resize.cur sw-resize.cur \
not-allowed.cur
WINCURSORS_ANI = wait.ani progress.ani
LWINCURSORS = default_left.cur help_left.cur pencil_left.cur pointer_left.cur
LWINCURSORS_ANI = progress_left.ani
THEME_NAME = Hackneyed
THEME_NAME_SMALL = $(THEME_NAME)-$(SIZE_SMALL)px
THEME_NAME_MEDIUM = $(THEME_NAME)-$(SIZE_MEDIUM)px
THEME_NAME_LARGE = $(THEME_NAME)-$(SIZE_LARGE)px
THEME_COMMENT = Windows 3.x-inspired cursors
THEME_EXAMPLE = default
THEME_WINDOWS = $(THEME_NAME)-Windows-$(VERSION)
SIZES ?= $(SIZE_SMALL) $(SIZE_MEDIUM) $(SIZE_LARGE) $(SIZE_LARGE1) $(SIZE_LARGE2)
PREVIEW_SIZE = $(SIZE_SMALL)
XCURSORGEN = xcursorgen
.DEFAULT_GOAL = all-dist
PREFIX ?= /usr/local
WAIT_FRAMES=16
WAIT_DEFAULT_FRAMETIME=30
WAIT_CUSTOM_FRAMETIMES=frame_5_time=300
PROGRESS_FRAMES=16
PROGRESS_DEFAULT_FRAMETIME=30
PROGRESS_CUSTOM_FRAMETIMES=frame_5_time=300
WINDOWS_WAIT_DEFAULT_FRAMETIME=2
WINDOWS_WAIT_CUSTOM_FRAMETIMES=frame_5_time=15
WINDOWS_PROGRESS_DEFAULT_FRAMETIME=2
WINDOWS_PROGRESS_CUSTOM_FRAMETIMES=frame_5_time=15

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

windows-cursors: $(WINCURSORS) $(LWINCURSORS) $(WINCURSORS_ANI) $(LWINCURSORS_ANI)
	rm -rf $(THEME_WINDOWS) $(THEME_WINDOWS).zip
	mkdir -p $(THEME_WINDOWS)
	cp $(WINCURSORS) $(LWINCURSORS) $(WINCURSORS_ANI) $(LWINCURSORS_ANI) $(THEME_WINDOWS)
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
	tar -jcof $(THEME_NAME_MEDIUM)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_MEDIUM)

dist.large.left: theme.large.left
	tar -jcof $(THEME_NAME_LARGE)-$(VERSION)-left-handed.tar.bz2 L$(THEME_NAME_LARGE)

theme: all
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/scalable/1; \
		s/THEME_COMMENT/$(THEME_COMMENT)/1; \
		s/THEME_EXAMPLE/$(THEME_EXAMPLE)/1" index.theme.template > $(THEME_NAME)/index.theme
	./do-symlinks.sh $(THEME_NAME)/cursors

theme.left: all.left
	sed "s/THEME_NAME/$(THEME_NAME)/1; \
		s/THEME_DESC/left-handed, scalable/1; \
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

all: $(CURSORS) $(COMMON_CURSORS)
	rm -rf $(THEME_NAME)
	mkdir -p $(THEME_NAME)/cursors
	cp $(CURSORS) $(COMMON_CURSORS) $(THEME_NAME)/cursors
#	echo \(trim-cursor-files "\"$(THEME_NAME)/cursors/*\""\)|cat trim-cursor-files.scm - |gimp -i -b -

all.left: $(LCURSORS) $(COMMON_CURSORS)
	rm -rf L$(THEME_NAME)
	mkdir -p L$(THEME_NAME)/cursors
	cp $(COMMON_CURSORS) L$(THEME_NAME)/cursors
	for l in $(LCURSORS); do \
		new_name=`echo $$l|sed 's/.left$$//'`; \
		cp $$l L$(THEME_NAME)/cursors/$$new_name; \
	done
#	echo \(trim-cursor-files "\"L$(THEME_NAME)/cursors/*\""\)|cat trim-cursor-files.scm - |gimp -i -b -

all.small: $(CURSORS_SMALL) $(COMMON_SMALL)
	rm -rf $(THEME_NAME_SMALL)
	mkdir -p $(THEME_NAME_SMALL)/cursors
	for l in $(CURSORS_SMALL) $(COMMON_SMALL); do \
		new_name=`echo $$l|sed 's/.$(SIZE_SMALL)$$//'`; \
		cp $$l $(THEME_NAME_SMALL)/cursors/$$new_name; \
	done

all.medium: $(CURSORS_MEDIUM) $(COMMON_MEDIUM)
	rm -rf $(THEME_NAME_MEDIUM)
	mkdir -p $(THEME_NAME_MEDIUM)/cursors
	for l in $(CURSORS_MEDIUM) $(COMMON_MEDIUM); do \
		new_name=`echo $$l|sed 's/.$(SIZE_MEDIUM)$$//'`; \
		cp $$l $(THEME_NAME_MEDIUM)/cursors/$$new_name; \
	done

all.large: $(CURSORS_LARGE) $(COMMON_LARGE)
	rm -rf $(THEME_NAME_LARGE)
	mkdir -p $(THEME_NAME_LARGE)/cursors
	for l in $(CURSORS_LARGE) $(COMMON_LARGE); do \
		new_name=`echo $$l|sed 's/.$(SIZE_LARGE)$$//'`; \
		cp $$l $(THEME_NAME_LARGE)/cursors/$$new_name; \
	done

all.small.left: $(LCURSORS_SMALL) $(COMMON_SMALL)
	rm -rf L$(THEME_NAME_SMALL)
	mkdir -p L$(THEME_NAME_SMALL)/cursors
	for l in $(COMMON_SMALL); do \
		new_name=`echo $$l|sed 's/.$(SIZE_SMALL)$$//'`; \
		cp $$l L$(THEME_NAME_SMALL)/cursors/$$new_name; \
	done
	for l in $(LCURSORS_SMALL); do \
		new_name=`echo $$l|sed 's/.$(SIZE_SMALL).left$$//'`; \
		cp $$l L$(THEME_NAME_SMALL)/cursors/$$new_name; \
	done

all.medium.left: $(LCURSORS_MEDIUM) $(COMMON_MEDIUM)
	rm -rf L$(THEME_NAME_MEDIUM)
	mkdir -p L$(THEME_NAME_MEDIUM)/cursors
	for l in $(COMMON_MEDIUM); do \
		new_name=`echo $$l|sed 's/.$(SIZE_MEDIUM)$$//'`; \
		cp $$l L$(THEME_NAME_MEDIUM)/cursors/$$new_name; \
	done
	for l in $(LCURSORS_MEDIUM); do \
		new_name=`echo $$l|sed 's/.$(SIZE_SMALL).left\$///'`; \
		cp $$l L$(THEME_NAME_MEDIUM)/cursors/$$new_name; \
	done

all.large.left: $(LCURSORS_LARGE) $(COMMON_LARGE)
	rm -rf L$(THEME_NAME_LARGE)
	mkdir -p L$(THEME_NAME_LARGE)/cursors
	for l in $(COMMON_LARGE); do \
		new_name=`echo $$l|sed 's/.$(SIZE_LARGE)$$//'`; \
		cp $$l L$(THEME_NAME_LARGE)/cursors/$$new_name; \
	done
	for l in $(LCURSORS_LARGE); do \
		new_name=`echo $$l|sed 's/.$(SIZE_LARGE).left$$//'`; \
		cp $$l L$(THEME_NAME_LARGE)/cursors/$$new_name; \
	done

%.in: theme/*/%.in
	{\
		unset size_set; \
		for s in $(SIZES); do \
			size_set="$$size_set theme/$$s/$@"; \
		done; \
		cat $$size_set > $@; \
	}

%_left.in: theme/*/%_left.in
	{\
		unset size_set; \
		for s in $(SIZES); do \
			size_set="$$size_set theme/$$s/$@"; \
		done; \
		cat $$size_set > $@; \
	}

%.png: $(RSVG_SOURCE) $(COMMON_SOURCE)
	{\
		target=`echo $@|cut -d. -f1`; \
		src=$<; \
		for c in $(COMMON_CURSORS); do \
			if [ "$$target" = "$$c" ]; then \
				export src=$(COMMON_SOURCE); \
				break; \
			fi; \
		done; \
		echo ">>> target: $$target"; \
		./make-png.sh src=$$src target=$$target size=`echo $@|cut -d. -f2` smallest_size=$(SIZE_SMALL) output=$@; \
	}

%.left.png: $(LSVG_SOURCE) $(COMMON_SOURCE)
	{\
		target=`echo $@|cut -d. -f1`; \
		src=$<; \
		for c in $(COMMON_CURSORS); do \
			if [ "$$target" = "$$c" ]; then \
				export src=$(COMMON_SOURCE); \
				break; \
			fi; \
		done; \
		echo ">>> target: $$target"; \
		./make-png.sh src=$$src target=$$target size=`echo $@|cut -d. -f2` smallest_size=$(SIZE_SMALL) output=$@; \
	}

%: %.in %.$(SIZE_SMALL).png %.$(SIZE_MEDIUM).png %.$(SIZE_LARGE).png %.$(SIZE_LARGE1).png %.$(SIZE_LARGE2).png
	$(XCURSORGEN) $< $@

%.left: %_left.in %.$(SIZE_SMALL).left.png %.$(SIZE_MEDIUM).left.png %.$(SIZE_LARGE).left.png %.$(SIZE_LARGE1).left.png %.$(SIZE_LARGE2).left.png
	$(XCURSORGEN) $< $@

%.$(SIZE_SMALL): theme/$(SIZE_SMALL)/%.in %.$(SIZE_SMALL).png
	$(XCURSORGEN) $< $@

%.$(SIZE_MEDIUM): theme/$(SIZE_MEDIUM)/%.in %.$(SIZE_MEDIUM).png
	$(XCURSORGEN) $< $@

%.$(SIZE_LARGE): theme/$(SIZE_LARGE)/%.in %.$(SIZE_LARGE).png
	$(XCURSORGEN) $< $@

%.$(SIZE_SMALL).left: theme/$(SIZE_SMALL)/%_left.in %.$(SIZE_SMALL).left.png
	$(XCURSORGEN) $< $@

%.$(SIZE_MEDIUM).left: theme/$(SIZE_MEDIUM)/%_left.in %.$(SIZE_MEDIUM).left.png
	$(XCURSORGEN) $< $@

%.$(SIZE_LARGE).left: theme/$(SIZE_LARGE)/%_left.in %.$(SIZE_LARGE).left.png
	$(XCURSORGEN) $< $@

png2cur: png2cur.c
	$(CC) -std=c99 -Wall -Werror -pedantic -g -o png2cur png2cur.c -lm `pkg-config --cflags --libs libpng MagickWand`

animaker: animaker.c
	$(CC) -std=c99 -Wall -Werror -pedantic -g -o animaker animaker.c

%_left.cur: theme/$(SIZE_SMALL)/%_left.in png2cur %.24.left.png %.48.left.png %.64.left.png
	{\
		set -- `cat $<`; \
		x=$$2; \
		y=$$3; \
		set -- $^; \
		shift 2; \
		./png2cur -x $$x -y $$y -o $@ $$*; \
	}

%.cur: theme/$(SIZE_SMALL)/%.in png2cur %.24.png %.48.png %.64.png
	{\
		set -- `cat $<`; \
		x=$$2; \
		y=$$3; \
		set -- $^; \
		shift 2; \
		./png2cur -x $$x -y $$y -o $@ $$*; \
	}

wait_all_frames: wait.$(SIZE_SMALL).frames wait.$(SIZE_MEDIUM).frames \
	wait.$(SIZE_LARGE).frames wait.$(SIZE_LARGE1).frames wait.$(SIZE_LARGE2).frames

wait_all_hotspots: wait.$(SIZE_SMALL).in wait.$(SIZE_MEDIUM).in wait.$(SIZE_LARGE).in \
	wait.$(SIZE_LARGE1).in wait.$(SIZE_LARGE2).in

progress_all_frames: progress.$(SIZE_SMALL).frames progress.$(SIZE_MEDIUM).frames \
	progress.$(SIZE_LARGE).frames progress.$(SIZE_LARGE1).frames progress.$(SIZE_LARGE2).frames

progress_all_hotspots: progress.$(SIZE_SMALL).in progress.$(SIZE_MEDIUM).in progress.$(SIZE_LARGE).in \
	progress.$(SIZE_LARGE1).in progress.$(SIZE_LARGE2).in

progress_left_all_frames: progress.left.$(SIZE_SMALL).frames progress.left.$(SIZE_MEDIUM).frames \
	progress.left.$(SIZE_LARGE).frames progress.left.$(SIZE_LARGE1).frames progress.left.$(SIZE_LARGE2).frames

progress_left_all_hotspots: progress.left.$(SIZE_SMALL).in progress.left.$(SIZE_MEDIUM).in progress.left.$(SIZE_LARGE).in \
	progress.left.$(SIZE_LARGE1).in progress.left.$(SIZE_LARGE2).in

wait.%.frames: $(COMMON_SOURCE) make-png.sh
	{\
		target=`echo $@|cut -d. -f1`; \
		size=`echo $@|cut -d. -f2`; \
		./make-png.sh src=$< target=$$target size=$$size smallest_size=$(SIZE_SMALL) frames=$(WAIT_FRAMES); \
	}

progress.%.frames: $(RSVG_SOURCE) make-png.sh
	{\
		target=`echo $@|cut -d. -f1`; \
		size=`echo $@|cut -d. -f2`; \
		./make-png.sh src=$< target=$$target size=$$size smallest_size=$(SIZE_SMALL) frames=$(PROGRESS_FRAMES); \
	}

progress.left.%.frames: $(LSVG_SOURCE) make-png.sh
	{\
		target=`echo $@|cut -d. -f1,2`; \
		size=`echo $@|cut -d. -f3`; \
		./make-png.sh src=$< target=$$target size=$$size smallest_size=$(SIZE_SMALL) frames=$(PROGRESS_FRAMES); \
	}

wait.%.in: theme/%/wait.in make-ani-hotspots.sh
	{\
		target=`echo $@|cut -d. -f1`; \
		size=`echo $@|cut -d. -f2`; \
		./make-ani-hotspots.sh target=$$target size=$$size frames=$(WAIT_FRAMES) \
			default_frametime=$(WAIT_DEFAULT_FRAMETIME) \
			$(WAIT_CUSTOM_FRAMETIMES); \
	}

wait.%: wait.%.in
	$(XCURSORGEN) $< $@

wait: wait_all_frames wait_all_hotspots
	cat wait.*.in|$(XCURSORGEN) - $@

wait.ani: png2cur animaker make-windows-ani.sh wait.24.frames wait.48.frames wait.64.frames
	./make-windows-ani.sh target=wait output_ani=$@ frames=$(WAIT_FRAMES) \
		default_frametime=$(WINDOWS_WAIT_DEFAULT_FRAMETIME) $(WINDOWS_WAIT_CUSTOM_FRAMETIMES) \
		hotspot_48=23,23 hotspot_64=31,31

progress.ani: png2cur animaker make-windows-ani.sh progress.24.frames progress.48.frames progress.64.frames
	./make-windows-ani.sh target=progress output_ani=$@ frames=$(PROGRESS_FRAMES) \
		default_frametime=$(WINDOWS_PROGRESS_DEFAULT_FRAMETIME) $(WINDOWS_PROGRESS_CUSTOM_FRAMETIMES)

progress_left.ani: png2cur animaker make-windows-ani.sh progress.left.24.frames progress.left.48.frames progress.left.64.frames
	./make-windows-ani.sh target=progress.left output_ani=$@ frames=$(PROGRESS_FRAMES) \
		default_frametime=$(WINDOWS_PROGRESS_DEFAULT_FRAMETIME) $(WINDOWS_PROGRESS_CUSTOM_FRAMETIMES)

progress: progress_all_frames progress_all_hotspots
	cat progress.*.in|$(XCURSORGEN) - $@

progress.%: progress.%.in
	$(XCURSORGEN) $< $@

progress.%.in: theme/%/progress.in make-ani-hotspots.sh
	{\
		target=`echo $@|cut -d. -f1`; \
		size=`echo $@|cut -d. -f2`; \
		./make-ani-hotspots.sh target=$$target size=$$size frames=$(PROGRESS_FRAMES) \
			default_frametime=$(PROGRESS_DEFAULT_FRAMETIME) \
			$(PROGRESS_CUSTOM_FRAMETIMES); \
	}

progress_left.%.in: theme/%/progress_left.in make-ani-hotspots.sh
	{\
		target=`echo $@|cut -d. -f1`; \
		target=`echo $$target|sed 's/_/./'`; \
		size=`echo $@|cut -d. -f2`; \
		./make-ani-hotspots.sh target=$$target size=$$size frames=$(PROGRESS_FRAMES) \
			default_frametime=$(PROGRESS_DEFAULT_FRAMETIME) \
			$(PROGRESS_CUSTOM_FRAMETIMES); \
	}

progress.left: progress_left_all_frames progress_left.$(SIZE_SMALL).in progress_left.$(SIZE_MEDIUM).in progress_left.$(SIZE_LARGE).in progress_left.$(SIZE_LARGE1).in progress_left.$(SIZE_LARGE2).in
	cat progress_left.*.in|$(XCURSORGEN) - $@

progress.%.left: progress_left.%.in
	$(XCURSORGEN) $< $@

preview: $(COMMON_SMALL) $(PNG_SMALL) $(LPNG_SMALL) wait-1.$(PREVIEW_SIZE).png progress-1.$(PREVIEW_SIZE).png progress-1.$(PREVIEW_SIZE).left.png
	montage -background none -mode concatenate -tile 9x6 -geometry +10+5 \
		default.$(PREVIEW_SIZE).png help.$(PREVIEW_SIZE).png progress-1.$(PREVIEW_SIZE).png \
		alias.$(PREVIEW_SIZE).png copy.$(PREVIEW_SIZE).png context-menu.$(PREVIEW_SIZE).png \
		no-drop.$(PREVIEW_SIZE).png dnd-move.$(PREVIEW_SIZE).png center_ptr.$(PREVIEW_SIZE).png \
		help.$(PREVIEW_SIZE).left.png progress-1.$(PREVIEW_SIZE).left.png alias.$(PREVIEW_SIZE).left.png \
		copy.$(PREVIEW_SIZE).left.png context-menu.$(PREVIEW_SIZE).left.png no-drop.$(PREVIEW_SIZE).left.png \
		dnd-move.$(PREVIEW_SIZE).left.png default.$(PREVIEW_SIZE).left.png right_ptr.$(PREVIEW_SIZE).left.png \
		wait-1.$(PREVIEW_SIZE).png pointer.$(PREVIEW_SIZE).png openhand.$(PREVIEW_SIZE).png \
		closedhand.$(PREVIEW_SIZE).png sw-resize.$(PREVIEW_SIZE).png se-resize.$(PREVIEW_SIZE).png w-resize.$(PREVIEW_SIZE).png \
		e-resize.$(PREVIEW_SIZE).png n-resize.$(PREVIEW_SIZE).png s-resize.$(PREVIEW_SIZE).png \
		nw-resize.$(PREVIEW_SIZE).png ne-resize.$(PREVIEW_SIZE).png split_v.$(PREVIEW_SIZE).png zoom.$(PREVIEW_SIZE).png \
		zoom-in.$(PREVIEW_SIZE).png zoom-out.$(PREVIEW_SIZE).png nesw-resize.$(PREVIEW_SIZE).png \
		nwse-resize.$(PREVIEW_SIZE).png ew-resize.$(PREVIEW_SIZE).png ns-resize.$(PREVIEW_SIZE).png split_h.$(PREVIEW_SIZE).png \
		text.$(PREVIEW_SIZE).png vertical-text.$(PREVIEW_SIZE).png move.$(PREVIEW_SIZE).png crosshair.$(PREVIEW_SIZE).png plus.$(PREVIEW_SIZE).png \
		not-allowed.$(PREVIEW_SIZE).png pirate.$(PREVIEW_SIZE).png X_cursor.$(PREVIEW_SIZE).png \
		wayland-cursor.$(PREVIEW_SIZE).png draft.$(PREVIEW_SIZE).png pencil.$(PREVIEW_SIZE).png \
		color-picker.$(PREVIEW_SIZE).png sb_up_arrow.$(PREVIEW_SIZE).png sb_right_arrow.$(PREVIEW_SIZE).png sb_left_arrow.$(PREVIEW_SIZE).png \
		preview-$(THEME_NAME).png
	montage -background none -mode concatenate -tile 4x4 -geometry +5+5 \
		default.$(PREVIEW_SIZE).png help.$(PREVIEW_SIZE).png progress-1.$(PREVIEW_SIZE).png no-drop.$(PREVIEW_SIZE).png wait-1.$(PREVIEW_SIZE).png \
		pencil.$(PREVIEW_SIZE).png zoom-in.$(PREVIEW_SIZE).png context-menu.$(PREVIEW_SIZE).png \
		pointer.$(PREVIEW_SIZE).png openhand.$(PREVIEW_SIZE).png closedhand.$(PREVIEW_SIZE).png pirate.$(PREVIEW_SIZE).png \
		n-resize.$(PREVIEW_SIZE).png s-resize.$(PREVIEW_SIZE).png w-resize.$(PREVIEW_SIZE).png e-resize.$(PREVIEW_SIZE).png \
		preview-small-$(THEME_NAME).png

clean:
	rm -rf $(THEME_WINDOWS)
	rm -rf $(THEME_NAME) L$(THEME_NAME) $(THEME_NAME_SMALL) $(THEME_NAME_MEDIUM) $(THEME_NAME_LARGE) \
		L$(THEME_NAME_SMALL) L$(THEME_NAME_MEDIUM) L$(THEME_NAME_LARGE)
	rm -f $(CURSORS)
	rm -f $(CURSORS_SMALL)
	rm -f $(CURSORS_MEDIUM)
	rm -f $(CURSORS_LARGE)
	rm -f $(CURSORS_LARGE1)
	rm -f $(CURSORS_LARGE2)
	rm -f $(LCURSORS)
	rm -f $(LCURSORS_SMALL)
	rm -f $(LCURSORS_MEDIUM)
	rm -f $(LCURSORS_LARGE)
	rm -f $(LCURSORS_LARGE1)
	rm -f $(LCURSORS_LARGE2)
	rm -f $(PNG_SMALL)
	rm -f $(PNG_MEDIUM)
	rm -f $(PNG_LARGE)
	rm -f $(PNG_LARGE1)
	rm -f $(PNG_LARGE2)
	rm -f $(LPNG_SMALL)
	rm -f $(LPNG_MEDIUM)
	rm -f $(LPNG_LARGE)
	rm -f $(LPNG_LARGE1)
	rm -f $(LPNG_LARGE2)
	rm -f $(COMMON_CURSORS)
	rm -f $(COMMON_SMALL)
	rm -f $(COMMON_MEDIUM)
	rm -f $(COMMON_LARGE)
	rm -f $(COMMON_LARGE1)
	rm -f $(COMMON_LARGE2)
	rm -f $(PNG_COMMON_SMALL)
	rm -f $(PNG_COMMON_MEDIUM)
	rm -f $(PNG_COMMON_LARGE)
	rm -f $(PNG_COMMON_LARGE1)
	rm -f $(PNG_COMMON_LARGE2)
	rm -f wait*.png progress*.png
	rm -f $(WINCURSORS) $(LWINCURSORS) $(WINCURSORS_ANI) $(LWINCURSORS_ANI)
	rm -f *.in png2cur animaker
	rm -f *.64*.png
	rm -f *.cur

.PHONY: all all-dist all.left all.small all.medium all.large all.small.left all.medium.left all.large.left \
	clean dist dist.left dist.small dist.medium dist.large dist.small.left dist.medium.left dist.large.left \
	install pack preview source-dist theme theme.left theme.small theme.medium theme.large theme.small.left \
	theme.medium.left theme.large.left windows-cursors all-sizes all-themes wait.%.frames \
	progress.%.frames progress.left.%.frames wait_all_frames progress_all_frames \
	progress_left_all_frames wait_all_hotspots progress_all_hotspots progress_left_all_hotspots
.SUFFIXES:
.PRECIOUS: %.in %_left.in %.png %.left.png
.DELETE_ON_ERROR:
