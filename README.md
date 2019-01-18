![hackneyed-light-preview](preview-Hackneyed.png "The sands of time are running out for you, bro")
![hackneyed-dark-preview](preview-Hackneyed-Dark.png "SO DAAAARK! SO PUUUUURE!")

Overview
--------

Hackneyed is a scalable cursor theme mildly resembing old Windows 3.x/NT 3.x cursors. Dark and left-handed versions are also available.


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

* `pack`: build both scalable themes (left- and right-handed) into a single package;
* `dist`: build the scalable, right-handed theme;
* `dist.left`: build the scalable, left-handed theme;
* `dist.<size>`, where `size` can be small, medium or large: build a fixed-size, right-handed theme of the specified size;
* `dist.<size>.left`: build a fixed-size, left-handed theme of the specified size;
* `windows-cursors` for Windows. These are high color cursors and will only work on Windows XP and later.

`make all-dist` targets all of the above (except `windows-cursors`), including all fixed-size themes in all available sizes.

`small`, `medium` and `large` are currently defined as 24, 36 and 48, respectively. The making of individual cursors recognizes the integer argument only (see below).

The targets described below are meant for debugging and do not generate tarballs:

* `theme`: make the scalable, right-handed theme;
* `theme.left`: make the scalable, right-handed theme;
* `theme.<size>`: make a fixed-size, right-handed theme of the specified size;
* `theme.<size>.left`: make a fixed-size, left-handed theme of the specified size.

All of them run `do-symlinks.sh` when finished. The targets below do not:

* `all`: make the scalable, right-handed theme;
* `all.<size>`: make a fixed-size, right-handed theme of the specified size;
* `all.left`: make the scalable, left-handed theme;
* `all.<size>.left`: make a fixed-size, left-handed theme of the specified size.

Individual cursors can be made with `make <cursor_name>.<size in pixels>.<orientation>`, e.g.:

* `make default.24.left` for a left-handed, 24px `default` cursor;
* `make default.24` for a right-handed, 24px cursor;
* `make default.left` for a scalable, left-handed cursor;
* `make default.24.png` for a 24px PNG only. PNG sizes aren't hardcoded, so you can specify any size you want;
* or simply `make default` for a scalable, right-handed cursor.

Parallel jobs (`-j`) are recommended (Inkscape is _slow_).

If you don't feel like building it from source, grab the latet builds from the artwork page on [openDesktop.org](https://www.opendesktop.org/p/999998/) or from [Gitlab](https://gitlab.com/Enthymeme/hackneyed-x11-cursors/tags).

To build the dark theme, tell `make` to use the dark versions of `COMMON_SOURCE`, `RSVG_SOURCE` and `LSVG_SOURCE`, and change `THEME_NAME`:

`$ make -B THEME_NAME=Hackneyed-Dark COMMON_SOURCE=theme/common-dark.svg RSVG_SOURCE=theme/right-handed-dark.svg LSVG_SOURCE=theme/left-handed-dark.svg <target>`


Installation
------------
Simply choose a tarball and extract it to `$HOME/.icons`. If you've built it from source, pick a size or variant (e.g., `Hackneyed`, `LHackneyed-36x36`) and move it to `$HOME/.icons`.


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
(as in "Cursor hash XXXXX returns 0xdeadbeef").

Useful links
------------
* [Freedesktop.org's cursor specification](http://www.freedesktop.org/wiki/Specifications/cursor-spec/)

* [CSS cursors from W3C](http://dev.w3.org/csswg/css-ui/#propdef-cursor "2drafty4u")

* [Mozilla's test page for CSS cursors](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor)

* [Qt requirements for X11 cursors](http://doc.qt.io/qt-5/qcursor.html#a-note-for-x11-users)

* [Core X11 cursors](http://tronche.com/gui/x/xlib/appendix/b/ "coffee_mug > all")

* [ComixCursors README](http://www.filewatcher.com/d/Debian/all/x11/comixcursors-lefthanded-opaque_0.7.2-3_all.deb.2350708.html)


Dealing with inconsistent cursors
---------------------------------
Setting the cursor theme through a graphical interface doesn't always propagate to all applications. _Most of the time_, this can be solved by creating a file called `index.theme` with the following content...

```
[Icon Theme]
inherits=Hackneyed
```

...and saving it in `~/.icons/default` (create this folder if it doesn't exist already).


On Xfce
-------
Xfce doesn't fully load a custom cursor theme at login unless you set a splash screen to show up while the DE is loading. There seems to be a race condition in which the session manager loads user settings after starting the window manager, resulting in mixed up cursors. This only happens when the usual display manager for Xfce distros, LightDM, is used with the GTK+ greeter. Restarting Xfwm4 (with `xfwm4 --replace`) also fixes it, although it's annoying to run it whenever you log in.

Plasma on Wayland
-----------------
Plasma 5 makes a mess with the pointers. I will look into it as soon as Plasma becomes usable under Wayland, and I don't think reporting such a bug at this stage is appropriate: they have more important things to care about.

Out of curiosity, starting a Wayland session with a [debug theme](https://gitlab.com/Enthymeme/xcursor-debug-theme) shows KWin's default pointer as `left_ptr` (a symlink to `default`), while the Plasma shell and other applications employ `left_arrow`, which looks like a Qt bug (Breeze has no `left_arrow`, forcing a fallback to `default` or one of the symlinks to it). KWin, though, replaces `size_bdiag` with `size_fdiag` when you drag the pointer to resize a window.


Chromium 62 and up
------------------
Recent versions of Chromium pull out whatever cursors the theme provides. Still, Chromium developers assumed that `all-scroll` and `move` are the same thing -- they aren't, but I don't believe this warrants a bug report.


TODO
----
A way to automate the making of ANI cursors for Windows. But don't count on that.
