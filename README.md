![hackneyed-preview](https://raw.githubusercontent.com/Enthymem/hackneyed-x11-cursors/master/preview.png)

Overview
--------

Hackneyed is an X11 cursor theme created for personal use, and published *pro bono* because it may be interesting to others. Inspired by old Windows 3.x cursors, Hackneyed brings an old school feel to whatever trendy desktop paradigm you're being subjected to.


Building
--------
Minimum dependencies:

* ImageMagick (>=6.8.6)
* Inkscape (>=0.48.4)
* GNU make
* xcursorgen

Extra functionality has additional dependencies:

* The GIMP script requires GIMP >= 2.2 with the XMC plugin installed;
* A working C compiler (for ico2cur), and p7zip, to generate Windows cursors.

Production targets (all of them generate tarballs for distribution):

* `pack`: build both multi-sized themes (left- and right-handed) into a single package;
* `dist`: build the multi-sized, right-handed theme;
* `dist.left`: build the multi-sized, left-handed theme;
* `dist.x`, where x can be 32, 48 or 64: build a single-sized, right-handed theme of the specified size;
* `dist.x.left`, where x can be 32, 48 or 64: build a single-sized, left-handed theme of the specified size;
* `windows-cursors` for Windows.

`make all-dist` targets all of the above, including all single-sized themes in all available sizes.

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

If you don't feel like building it from source, grab the latest builds from [the "Releases" page](https://github.com/Enthymem/hackneyed-x11-cursors/releases) on GitHub, or from the artwork page on [xfce-look.org](https://www.xfce-look.org/p/999998/).
The Windows version can only be found on GitHub.

Hackneyed's build system is simply a collection of shell scripts and a Makefile. It wasn't hard to write, and it shouldn't be hard to understand.

License
-------
Hackneyed is released under the MIT/X11 license.

Credits
-------
* do-symlinks.sh, rewrite of addmissing.sh, taken from dummy-x11-cursors by ultr (on kde-look.org)

* some SVGs taken from openclipart.org (pencil, pirate and coffee_mug as far as I can remember)

* monolithic SVG idea (and the SVG itself) taken from KDE's Breeze theme by Ken Vermette, who probably liked Jakub Steiner's DMZ way too much (but not enough to keep the Python script)

* util/ico2cur.c, a C rendition of [ico2cur.py](https://code.google.com/archive/p/ico2cur/)

Bugs
----
Please report, either here or on Xfce-look, any bugs you might find, or any enhancements you might want. I consider it finished, but there's always a corner to round.

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
* [Freedesktop.org's cursor specification](http://www.freedesktop.org/wiki/Specifications/cursor-spec/ "The best standards are those followed without any obligation")

* [CSS cursors](http://dev.w3.org/csswg/css-ui/#propdef-cursor "2drafty4u")

* [Test page for CSS cursors](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor "Firefox is the only browser that uses more than a couple of cursors from the X11 theme")

* [Qt requirements for X11 cursors](http://qt-project.org/doc/qt-4.8/qcursor.html#a-note-for-x11-users "Qt beyond measure")

* [Core X11 cursors](http://tronche.com/gui/x/xlib/appendix/b/ "coffee_mug > all")

* [ComixCursors README](http://www.filewatcher.com/d/Debian/all/x11/comixcursors-lefthanded-opaque_0.7.2-3_all.deb.2350708.html "I blame Google for not finding this sooner")

On Xfce
-------
Xfce (at least on Fedora) doesn't fully load a custom cursor theme at login unless it's set as the "default" theme. There is a fix that works most of the time:

```
[Icon Theme]
Inherits=Hackneyed
```

Paste the two lines above into a file called "index.theme", save it on ~/.icons/default and set the mouse theme as "default". I say "most of the time" because there seems to be a race condition in which settings are sometimes loaded after the window manager, so you get mixed up cursors.
