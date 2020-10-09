{
  description = "X11 cursors with a spinning hourglass";

  inputs.nixpkgsOld.url = "github:NixOS/nixpkgs?rev=7b3a2963d1e8901df0d2b872485e14df4889c99a";

  outputs = { self, nixpkgs, nixpkgsOld }:
    let
      oldPkgs = import nixpkgsOld {
        system = "x86_64-linux";
      };

      overlay = final: prev: {
        hackneyed-x11-cursors = final.stdenv.mkDerivation {
          pname = "hackneyed-x11-cursors";
          version = "0.8.1";
          src = self;
          buildInputs = [ final.imagemagick oldPkgs.inkscape final.xorg.xcursorgen ];
          INKSCAPE = oldPkgs.inkscape + "/bin/inkscape";
          XCURSORGEN = final.xorg.xcursorgen + "/bin/xcursorgen";
          phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
          installPhase = builtins.readFile "${self}/build-quicker.sh";
        };
      };

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ overlay ];
      };

      pkg = pkgs.hackneyed-x11-cursors;
    in {
      inherit overlay;
      packages.x86_64-linux.hackneyed-x11-cursors = pkg;
      defaultPackage.x86_64-linux = pkg;
    };
}
