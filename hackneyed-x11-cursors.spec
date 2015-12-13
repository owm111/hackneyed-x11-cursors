Name:		hackneyed-cursor-theme	
Version:	0.3.23
Release:	1%{?dist}
Summary:	Windows 3.x-inspired cursors

Group:		Unspecified
License:	MIT
URL:		http://github.com/Enthymem/hackneyed-x11-cursors
Source0:	Hackneyed-%{version}.tar.bz2

BuildRequires:	xorg-x11-apps inkscape ImageMagick make

%description
Inspired by old Windows 3.x cursors, the Hackneyed cursor theme for X11 brings an old-school feel to your wobbly-windowed, blocky and docky desktop of today.

%prep
%setup -q


%build
# Parallelization doesn't quite work yet
make theme theme.left


%install
%make_install PREFIX=/usr


%files
%doc README CHANGELOG LICENSE
%{_datadir}/icons/*Hackneyed

%changelog

