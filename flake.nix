{
  description = "A flake for midnight commander";

  inputs = {

    nixpkgs = {
	    url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    mc = {
      url = "github:MidnightCommander/mc";
      flake = false;
    };

  };


  outputs = { self, nixpkgs, mc, }:
  let 
    system = "x86_64-linux";

    pkgs = import nixpkgs {
        inherit system;
      };

    feh = pkgs.feh;

    mc-custom = pkgs.mc.overrideAttrs (oldAttrs: {
      postPatch = oldAttrs.postPatch + ''
        # echo "Listing the contents of the source directory:"
        # ls -laR

        install -D ${./config/mc.keymap} ./misc/mc.default.keymap
        install -D ${./config/skins/default.ini} ./misc/skins/default.ini
        install -D ${./config/mc.ext.ini} ./misc/mc.ext.ini
        install -D ${./config/setup.c} ./src/setup.c
        # install -D ${./config/ini} ./mc/mc.ini
      '';
    });

  in {
    inherit system;
    inherit mc-custom;
    inherit feh;

    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      buildInputs = [
            mc-custom
            feh
      ];
    };

    packages.${system}.default = mc-custom;

  };
}

