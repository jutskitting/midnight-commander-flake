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

        #   postPatch = oldAttrs.postPatch + ''
        #     echo "Listing the contents of the source directory:"
        #     echo "$(cat ./misc/mc.ext.ini.in)"
        # '';
        #

          patches = [
            ./patches/changes.patch
          ];
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

