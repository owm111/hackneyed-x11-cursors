{ stdenv, inkscape, xcursorgen }:

stdenv.mkDerivation {
  pname = "hackneyed-x11-cursors";
  version = "0.8.2";

  src = ./.;

  INKSCAPE = "${inkscape}/bin/inkscape";

  buildInputs = [ xcursorgen ];

  patches = [
    # ./fix-paths.diff
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace /usr/local "$out"
  '';

  dontBuild = true;

  installPhase = ''
    make -O install
    make -O COMMON_SOURCE=theme/common-dark.svg RSVG_SOURCE=theme/right-handed-dark.svg LSVG_SOURCE=theme/left-handed-dark.svg THEME_NAME=Hackneyed-Dark install
  '';
}
