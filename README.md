![hackneyed-preview](https://raw.githubusercontent.com/Enthymem/hackneyed-x11-cursors/master/preview.png "The sands of time are running out for you, bro")

Overview
--------

Hackneyed is a cursor theme inspired by the good old Windows 3.x cursors and retains their best features -- high-contrast and sensible use of colors -- along with sizes fit for high resolution screens; left-handed pointers are available, as well. It also brings an old school feel to whatever trendy desktop paradigm you're being subjected to. And hourglasses. Why did hourglasses disappear from cursor themes?


Building
--------
Minimum dependencies:

* ImageMagick (>=6.8.6)
* Inkscape (>=0.48.4)
* GNU `make`
* `xcursorgen` (part of the xorg-utils package)

Extra functionality has additional dependencies:

* The GIMP script requires GIMP >= 2.2 with the XMC plugin installed (the script isn't very useful anyway; cf. the comment in its header);
* A working C compiler for `ico2cur`, and `zip`, to generate and pack Windows cursors.

Production targets (all of them generate tarballs for distribution):

* `pack`: build both multi-sized themes (left- and right-handed) into a single package;
* `dist`: build the multi-sized, right-handed theme;
* `dist.left`: build the multi-sized, left-handed theme;
* `dist.x`, where x can be 32, 48 or 64: build a single-sized, right-handed theme of the specified size;
* `dist.x.left`, where x can be 32, 48 or 64: build a single-sized, left-handed theme of the specified size;
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

* `make default.32.left` for a left-handed, 32x32-sized `default` cursor;
* `make default.32` for a right-handed, 32x32-sized cursor;
* `make default.left` for a multi-sized, left-handed cursor;
* or simply `make default` for a multi-sized, right-handed cursor.

If you don't feel like building it from source, grab the latest builds from [the "Releases" page](https://github.com/Enthymem/hackneyed-x11-cursors/releases) on GitHub, or from the artwork page on [openDesktop.org](https://www.opendesktop.org/p/999998/). Windows cursor files, for those who hate the Aero cursors as much as I do, can only be found on GitHub.

Hackneyed's build system is simply a collection of shell scripts and a Makefile. It wasn't hard to write, and it shouldn't be hard to understand.

License
-------
Hackneyed is released under the MIT/X11 license.

Credits
-------
* do-symlinks.sh, rewrite of addmissing.sh, taken from [dummy-x11-cursors](https://www.opendesktop.org/p/999853/) by ultr

* some SVGs taken from openclipart.org (pencil, pirate and coffee_mug as far as I can remember)

* monolithic SVG idea (and the SVG itself) taken from KDE's [Breeze theme](https://github.com/KDE/breeze/tree/master/cursors) by Ken Vermette, who probably liked Jakub Steiner's DMZ way too much (but not enough to keep the Python script)

* util/ico2cur.c, a C rendition of [ico2cur.py](https://gist.github.com/RyanBalfanz/2371463)


Bugs
----
Please report, either here or on openDesktop.org, any bugs you might find, or any enhancements you might want. I consider it finished, but there's always a corner to round.


A word about hashes
-------------------
libXcursor has an undocumented "hash logger", which is triggered when one exports a variable called
XCURSOR_DISCOVER, no matter the value. The hashes are printed on the terminal, so it's important
that you don't do this from a graphical application launcher. The code is in xlib.c, in a function called
XcursorLogDiscover.

You should not take into account the hashes for masks, i.e., the filled
"images" displayed. Only consider hashes that return some random hex number
(as in "Cursor hash XXXXX returns 0xdeadbeef"). Applications seem to be migrating away from libXcursor, so that cursor theming through hashes might become a thing of the past.

Useful links
------------
* [Freedesktop.org's cursor specification](http://www.freedesktop.org/wiki/Specifications/cursor-spec/)

* [CSS cursors](http://dev.w3.org/csswg/css-ui/#propdef-cursor "2drafty4u")

* [Test page for CSS cursors](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor "Firefox is the only browser that uses more than a couple of cursors from the X11 theme")

* [Qt requirements for X11 cursors](http://doc.qt.io/qt-5/qcursor.html#a-note-for-x11-users)

* [Core X11 cursors](http://tronche.com/gui/x/xlib/appendix/b/ "coffee_mug > all")

* [ComixCursors README](http://www.filewatcher.com/d/Debian/all/x11/comixcursors-lefthanded-opaque_0.7.2-3_all.deb.2350708.html)

On Xfce
-------
Xfce doesn't fully load a custom cursor theme at login unless you set a splash screen to show up while the DE is loading. There seems to be a race condition in which the session manager loads user settings after starting the window manager, resulting in mixed up cursors. This only happens in LightDM, the usual display manager for Xfce distros, with the GTK+ greeter. Restarting Xfwm4 (with `xfwm4 --replace`) also fixes it, although it's annoying to run it whenever you log in.

Plasma on Wayland
-----------------
Plasma 5 makes a mess with the pointers, which doesn't happen with its stock theme (Breeze); on the other hand, GNOME has no trouble in picking up the same cursors it does under X11, and Weston shows no issues as well. I will look into it as soon as Plasma becomes usable under Wayland, and I don't think reporting a bug at this stage is appropriate: they surely have more important things to care about.

Out of curiosity, starting a Wayland session with a [debug theme](https://github.com/Enthymem/xcursor-debug-theme) shows that KWin's default pointer is `left_ptr` (a symlink to `default`), which is correct, but the Plasma shell employs `left_arrow`. KWin, though, uses `size_bdiag` as `size_fdiag` (and vice-versa), despite them pointing to the same shapes as the Breeze theme. Spooky.
