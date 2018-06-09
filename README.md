![hackneyed-preview](https://gitlab.com/Enthymeme/hackneyed-x11-cursors/raw/master/preview.png "The sands of time are running out for you, bro")

Overview
--------

Hackneyed is a scalable cursor theme mildly resembing old Windows 3.x/NT 3.x cursors. Left-handed pointers are available, as well.


Building
--------
Minimum dependencies:

* ImageMagick (>=6.8.6)
* Inkscape (>=0.92.3, older versions will make a mess with the DPI settings)
* GNU `make` and `bash` (really, a POSIX shell won't cut it)
* `xcursorgen` (part of the xorg-utils package)

Extra functionality has additional dependencies:

* The GIMP script requires GIMP >= 2.2 with the XMC plugin installed (the script isn't very useful anyway; refer to the in-file comments);
* A working C compiler for `ico2cur`, and `zip`, to generate and pack Windows cursors.

Production targets (all of them generate tarballs for distribution):

* `pack`: build both multi-sized themes (left- and right-handed) into a single package;
* `dist`: build the multi-sized, right-handed theme;
* `dist.left`: build the multi-sized, left-handed theme;
* `dist.x`, where x can be 24, 36 or 48: build a single-sized, right-handed theme of the specified size;
* `dist.x.left`, where x can be 24, 36 or 48: build a single-sized, left-handed theme of the specified size;
* `windows-cursors` for Windows.

`make all-dist` targets all of the above (except `windows-cursors`), including all single-sized themes in all available sizes.

The targets described below are meant for debugging and do not generate tarballs:

* `theme`: make the multi-sized, right-handed theme;
* `theme.left`: make the multi-sized, right-handed theme;
* `theme.x`: make a single-sized, right-handed theme of the specified size;
* `theme.x.left`: make a single-sized, left-handed theme of the specified size.

All of them run `do-symlinks.sh` when finished. The targets below do not:

* `all`: make the multi-sized, right-handed theme;
* `all.x`: make a single-sized, right-handed theme of the specified size;
* `all.left`: make the multi-sized, left-handed theme;
* `all.x.left`: make a single-sized, left-handed theme of the specified size.

Individual cursors can be made with `make <cursor_name>.<size>.<orientation>`, e.g.:

* `make default.24.left` for a left-handed, 24px `default` cursor;
* `make default.24` for a right-handed, 24px cursor;
* `make default.left` for a multi-sized, left-handed cursor;
* `make default.24.png` for a 24px PNG only. PNG sizes aren't hardcoded, so you can specify any size you want;
* or simply `make default` for a multi-sized, right-handed cursor.

Parallel jobs (`-j`) are recommended (Inkscape is _slow_).

If you don't feel like building it from source, grab the latest builds from the artwork page on [openDesktop.org](https://www.opendesktop.org/p/999998/).


License
-------
Hackneyed is released under the MIT/X11 license.


Credits
-------
* do-symlinks.sh, rewrite of addmissing.sh, taken from [dummy-x11-cursors](https://www.opendesktop.org/p/999853/) by ultr

* some SVGs taken from openclipart.org (pencil, pirate and coffee_mug as far as I can remember)

* monolithic SVG idea (and the SVG itself) taken from KDE's [Breeze theme](https://github.com/KDE/breeze/tree/master/cursors) by Ken Vermette, who probably liked Jakub Steiner's DMZ way too much (but not enough to keep the Python script)

* ico2cur.c, a C rendition of [ico2cur.py](https://gist.github.com/RyanBalfanz/2371463)


Bugs
----
Please report, either here or on openDesktop.org, any bugs you might find, or any enhancements you might want.


A word about hashes
-------------------
libXcursor has an undocumented "hash logger", which is triggered when one exports a variable called
XCURSOR_DISCOVER, no matter the value. The hashes are printed on the terminal, so it's important
that you don't do this from a graphical application launcher. The code is in xlib.c, in a function called
XcursorLogDiscover.

You should not take into account the hashes for masks, i.e., the filled
"images" displayed. Only consider hashes that return some random hex number
(as in "Cursor hash XXXXX returns 0xdeadbeef"). Applications are migrating away from libXcursor, so cursor theming through hashes might become a thing of the past.

Useful links
------------
* [Freedesktop.org's cursor specification](http://www.freedesktop.org/wiki/Specifications/cursor-spec/)

* [CSS cursors](http://dev.w3.org/csswg/css-ui/#propdef-cursor "2drafty4u")

* [Test page for CSS cursors](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor)

* [Qt requirements for X11 cursors](http://doc.qt.io/qt-5/qcursor.html#a-note-for-x11-users)

* [Core X11 cursors](http://tronche.com/gui/x/xlib/appendix/b/ "coffee_mug > all")

* [ComixCursors README](http://www.filewatcher.com/d/Debian/all/x11/comixcursors-lefthanded-opaque_0.7.2-3_all.deb.2350708.html)

On Xfce
-------
Xfce doesn't fully load a custom cursor theme at login unless you set a splash screen to show up while the DE is loading. There seems to be a race condition in which the session manager loads user settings after starting the window manager, resulting in mixed up cursors. This only happens when the usual display manager for Xfce distros, LightDM, is used with the GTK+ greeter. Restarting Xfwm4 (with `xfwm4 --replace`) also fixes it, although it's annoying to run it whenever you log in.

Plasma on Wayland
-----------------
Plasma 5 makes a mess with the pointers. I will look into it as soon as Plasma becomes usable under Wayland, and I don't think reporting such a bug at this stage is appropriate: they have more important things to care about.

Out of curiosity, starting a Wayland session with a [debug theme](https://gitlab.com/Enthymeme/xcursor-debug-theme) shows KWin's default pointer as `left_ptr` (a symlink to `default`), while the Plasma shell and other applications employ `left_arrow`, which looks like a Qt bug (Breeze has no `left_arrow`, forcing a fallback to `default` or one of the symlinks to it). KWin, though, replaces `size_bdiag` with `size_fdiag` when you drag the pointer to resize a window.


Chromium 62 and up
------------------
Recent versions of Chromium pull out whatever cursors the theme provides. How nice. Still, Chromium developers assumed that `all-scroll` and `move` are the same thing (they aren't, but I don't believe this warrants a bug report).


TODO
----
A way to automate the making of ANI cursors for Windows. But don't count on that.
