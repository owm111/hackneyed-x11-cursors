include deps.mk config/overlay.mk config/transform.mk

CURSORS = default text pointer help progress wait copy alias no-drop \
not-allowed split_v split_h e-resize ne-resize nw-resize n-resize se-resize \
sw-resize s-resize w-resize vertical-text crosshair tcross up_arrow \
context-menu ew-resize ns-resize nesw-resize nwse-resize pencil right_ptr \
zoom zoom-in zoom-out pirate X_cursor closedhand openhand color-picker plus \
center_ptr move all-scroll dnd-move wayland-cursor down-arrow draft \
left-arrow right-arrow exchange ul_angle ur_angle ll_angle lr_angle \
based_arrow_down based_arrow_up
LCURSORS = alias.left color-picker.left context-menu.left copy.left \
default.left help.left pencil.left dnd-move.left zoom-in.left zoom.left \
zoom-out.left progress.left no-drop.left draft.left right_ptr.left
THEME_NAME = Hackneyed
VERSION = 0.3.18
SIZES ?= 32 40 48 56 64
PREVIEW_SIZE = 48
XCURSORGEN = xcursorgen
USE_INKSCAPE ?= 0
.DEFAULT_GOAL = pack

pack: theme theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-pack.tar.bz2 $(THEME_NAME) L$(THEME_NAME)

dist: theme
	tar -jcof $(THEME_NAME)-$(VERSION).tar.bz2 $(THEME_NAME)

ldist: theme.left
	tar -jcof $(THEME_NAME)-$(VERSION)-left.tar.bz2 L$(THEME_NAME)

theme: all
	./do-symlinks.sh $(THEME_NAME)/cursors
	./generate-metadata.sh target=$@ sizes="$(SIZES)" > $(THEME_NAME)/index.theme

theme.left: lall
	./do-symlinks.sh L$(THEME_NAME)/cursors
	./generate-metadata.sh target=$@ sizes="$(SIZES)" > L$(THEME_NAME)/index.theme

all: $(CURSORS)
	test -d $(THEME_NAME)/cursors || mkdir -p $(THEME_NAME)/cursors
	cp $(CURSORS) $(THEME_NAME)/cursors

lall: $(CURSORS) $(LCURSORS)
	test -d L$(THEME_NAME)/cursors || mkdir -p L$(THEME_NAME)/cursors
	cp $(CURSORS) L$(THEME_NAME)/cursors
	for l in $(LCURSORS); do \
		cp $$l L$(THEME_NAME)/cursors/$${l/.left/}; \
	done

wait: svg/wait-[1-9].svg conjure-frames.sh
	./conjure-frames.sh sizes="$(SIZES)" use_inkscape=$(USE_INKSCAPE) target=$@
	$(XCURSORGEN) wait.in $@

%.in:
	./make-config.sh sizes="$(SIZES)" target=$@

%.in_left:
	./make-config.sh sizes="$(SIZES)" target=$@

%: %.in
	./make-pngs.sh target=$@ use_inkscape=$(USE_INKSCAPE) sizes="$(SIZES)"
	$(XCURSORGEN) $@.in $@

%.left: %.in_left
	./make-pngs.sh target=$@ use_inkscape=$(USE_INKSCAPE) sizes="$(SIZES)"
	$(XCURSORGEN) $< $@

preview: $(CURSORS) $(LCURSORS)
	montage -background none -geometry +4+4 -mode concatenate -tile 9x10 \
		$(PREVIEW_SIZE)/{default,help,progress,alias,copy,context-menu,no-drop,dnd-move}.png \
		$(PREVIEW_SIZE)/{help,progress,alias,copy,context-menu,no-drop,dnd-move}_left.png \
		$(PREVIEW_SIZE)/{default_left,center_ptr,right_ptr_left}.png \
		$(PREVIEW_SIZE)/{pencil_left,color-picker_left,openhand}.png \
		$(PREVIEW_SIZE)/{nw-resize,n-resize,ne-resize,split_v,split_h}.png \
		$(PREVIEW_SIZE)/{zoom,zoom-in,zoom-out,pointer}.png \
		$(PREVIEW_SIZE)/{w-resize,wait-6,e-resize,text,ew-resize}.png \
		$(PREVIEW_SIZE)/{ns-resize,nesw-resize,nwse-resize}.png \
		$(PREVIEW_SIZE)/{closedhand,sw-resize}.png \
		$(PREVIEW_SIZE)/{s-resize,se-resize,vertical-text}.png \
		$(PREVIEW_SIZE)/{zoom,zoom-in,zoom-out}_left.png \
		$(PREVIEW_SIZE)/{move,crosshair,tcross,plus}.png \
		$(PREVIEW_SIZE)/{not-allowed,pencil}.png \
		$(PREVIEW_SIZE)/{pirate,color-picker,X_cursor,draft}.png \
		$(PREVIEW_SIZE)/{up_arrow,right-arrow,down-arrow,left-arrow,all-scroll,wayland-cursor}.png \
		preview.png

right_ptr: right_ptr.in default
	$(XCURSORGEN) $@.in $@

right_ptr.left: right_ptr.in_left center_ptr
	$(XCURSORGEN) right_ptr.in_left $@

split_h: split_h.in split_v
	$(XCURSORGEN) $@.in $@

w-resize: w-resize.in
n-resize: n-resize.in
s-resize: s-resize.in
se-resize: se-resize.in
sw-resize: sw-resize.in
down-arrow: down-arrow.in
left-arrow: left-arrow.in
right-arrow: right-arrow.in
ns-resize: ns-resize.in
nw-resize: nw-resize.in
nesw-resize: nesw-resize.in

based_arrow_down: based_arrow_down.in based_arrow_up
	$(XCURSORGEN) $@.in $@

ur_angle: ur_angle.in ul_angle
	$(XCURSORGEN) $@.in $@

ll_angle: ll_angle.in ul_angle
	$(XCURSORGEN) $@.in $@

lr_angle: lr_angle.in ul_angle
	$(XCURSORGEN) $@.in $@

w-resize n-resize s-resize: e-resize
	$(XCURSORGEN) $@.in $@

ns-resize: ew-resize
	$(XCURSORGEN) $@.in $@

nesw-resize: nwse-resize
	$(XCURSORGEN) $@.in $@

nw-resize se-resize sw-resize: ne-resize
	$(XCURSORGEN) $@.in $@

vertical-text: vertical-text.in text
	$(XCURSORGEN) $@.in $@

down-arrow left-arrow right-arrow: up_arrow
	$(XCURSORGEN) $@.in $@

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

.PHONY: preview clean theme theme.left all all.left dist dist.left pack
.PRECIOUS: %.in %.in_left
