![hackneyed-preview](https://raw.githubusercontent.com/Enthymem/hackneyed-x11-cursors/master/preview.png "Do you like big hands?")

Overview
--------

Hackneyed is an X11 cursor theme created for personal use. Inspired by old Windows 3.x cursors, Hackneyed brings an old school feel to your wobbly-windowed, docky and blocky desktop of today.

With the recent changes, though, Hackneyed has become nothing more than DMZ with hourglasses.

Building
--------
Make sure you have ImageMagick (>=6.8.6), Inkscape (>=0.48.4), GNU make and xcursorgen installed.
The GIMP script requires GIMP >= 2.2 with the XMC plugin installed.

`make pack` will drop you a tarball with the full theme, including the left-handed one. If you want either the left-
or the right-handed theme, use the targets `ldist` or `dist`, respectively.

Other useful targets: `all`, `theme` and `theme.left`. These only generate the cursor files without packing them.

If you don't feel like building it from source, grab the latest builds from [the "Releases" page](https://github.com/Enthymem/hackneyed-x11-cursors/releases) on GitHub, or from the artwork page on [xfce-look.org](https://www.xfce-look.org/p/999998/). The Windows version can only be found here.

Hackneyed's build system is simply a collection of shell scripts and a Makefile. It wasn't hard to write, and it shouldn't be hard to understand.

License
-------
Hackneyed is released under the MIT/X11 license.

Credits
-------
* do-symlinks.sh, rewrite of addmissing.sh, taken from dummy-x11-cursors by ultr (on kde-look.org)

* some SVGs taken from openclipart.org (pencil, pirate and coffee_mug as far as I can remember)

* monolithic SVG idea taken from KDE's Breeze theme by Ken Vermette, which probably took the idea from Jakub Steiner's DMZ

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

On XFCE
-------
XFCE (at least on Fedora) doesn't fully load a custom cursor theme at login unless it's set as the "default" theme. There is a fix that works most of the time:

```
[Icon Theme]
Inherits=Hackneyed
```

Paste the two lines above into a file called "index.theme", save it on ~/.icons/default and set the mouse theme as "default". I say "most of the time" because there seems to be a race condition in which settings are sometimes loaded after the window manager, so you get mixed up cursors.
