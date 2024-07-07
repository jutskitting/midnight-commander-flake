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

        mc-custom = pkgs.mc.overrideAttrs (oldAttrs: with pkgs; {

          patches = [
            ./patches/changes.patch
          ];

          # buildInputs = oldAttrs.buildInputs ++ [
          #   feh
          #   zathura
          #   makeWrapper
          # ];

          buildInputs = oldAttrs.buildInputs ++ [
              pkgs.makeWrapper
          ];

          # The install phase creates a wrapper script around `mc`.
          postIntall = ''
          '';
        });

      in {

        devShells.default = with lpkgs; with pkgs; mkShell {

          buildInputs = [
              mc-custom
              feh
              zathura
          ];

          shellHook = ''
            mc
            '';

        };

        packages.default = mc-custom;

      }
    );
}

