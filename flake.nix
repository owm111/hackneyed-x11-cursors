{
  description = "X11 cursors with a spinning hourglass";

  outputs = { self, nixpkgs }:
    let
      overlay = final: prev: {
        hackneyed-x11-cursors = final.stdenv.mkDerivation {
          pname = "hackneyed-x11-cursors";
          version = "0.8.1";
          src = self;
          buildInputs = [ final.imagemagick final.inkscape final.xorg.xcursorgen ];
          phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
          installPhase = builtins.readFile "${self}/build.sh";
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
