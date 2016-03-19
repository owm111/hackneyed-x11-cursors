Name:		hackneyed-cursor-theme	
Version:	0.3.24
Release:	1%{?dist}
Summary:	Windows 3.x-inspired cursors

Group:		Unspecified
License:	MIT
URL:		http://github.com/Enthymem/hackneyed-x11-cursors
Source0:	hackneyed-x11-cursors-%{version}.tar.gz

BuildRequires:	xorg-x11-apps inkscape ImageMagick make
BuildArch:	noarch

%description
Inspired by old Windows 3.x cursors, the Hackneyed cursor theme for X11
brings an old-school feel to your wobbly-windowed, blocky and docky desktop
of today. Available in sizes 32, 40, 48 56 and 64. Not all desktop environments
support all sizes.

%prep
%setup -q -n hackneyed-x11-cursors-%{version}


%build
# Parallelization doesn't quite work yet
make theme theme.left


%install
%make_install PREFIX=/usr


%files
%doc README.md CHANGELOG LICENSE
%{_datadir}/icons/*Hackneyed

%changelog

