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

    flake-utils.url = "github:numtide/flake-utils";

  };


  outputs = { self, nixpkgs, mc,flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let 

        pkgs = import nixpkgs {
            inherit system;
          };

        lpkgs = nixpkgs.legacyPackages {
                inherit system;
            };

        mc-custom = pkgs.mc.overrideAttrs (oldAttrs: {

          postPatch = oldAttrs.postPatch + ''
            echo "Listing the contents of the source directory:"
            echo "$(cat ./misc/mc.ext.ini.in)"
        '';
          #   ls  -laR
          #   install -D ${./config/mc.keymap} ./misc/mc.default.keymap
          #   install -D ${./config/skins/default.ini} ./misc/skins/default.ini
          #   install -D ${./config/mc.ext.ini} ./misc/mc.ext.ini.in
          #   install -D ${./config/setup.c} ./src/setup.c
          #   install -D ${./config/ini} ./mc/mc.ini
          # '';

          patches = [
            ./patches/changes.patch
          ];

          # installPhase = ''
          #      makeWrapper ${mc}/bin/mc $out/bin/mc-wrapper \
          #     --set XDG_CONFIG_HOME ./config/mc.keymap
          # '';
          #
        });

      in {

        devShells.default = with lpkgs; with pkgs; mkShell {
            buildInputs = [
                mc-custom
                feh
                zathura
            ];
        };

        packages.default = mc-custom;

        apps.default = {
            type = "app";
            program = "${mc-custom}/bin/mc";
        };

      }
    );
}

