{
  description = "A trivial but enhanced flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "unstable";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, nixpkgs, unstable, treefmt-nix, pre-commit-hooks, ... }:
    let
      config = {
        allowUnfree = true;
      };
      overlays = [
        (final: prev: {
          unstable = import unstable {
            inherit (prev) system;
            inherit config;
          };
        })
      ];
      forSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
        ]
          (system:
            function {
              inherit system;
              pkgs = import nixpkgs {
                inherit system overlays config;
              };
            }
          );

    in
    {
      formatter = forSystems ({ pkgs, system }: treefmt-nix.lib.mkWrapper pkgs.unstable {
        projectRootFile = "flake.nix";
        programs.nixpkgs-fmt.enable = true;
      });

      checks = forSystems ({ pkgs, system }: {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            statix.enable = true;
            markdownlint.enable = true;
            editorconfig-checker.enable = true;
            actionlint.enable = true;
          };
        };
      });

      devShells = forSystems ({ pkgs, system }: {
        default = pkgs.mkShell {
          packages = [
            pkgs.unstable.treefmt
            pkgs.unstable.nodePackages.markdownlint-cli
            pkgs.unstable.editorconfig-checker
            pkgs.unstable.actionlint
          ];
          inherit (self.checks."${system}".pre-commit-check) shellHook;
        };
      });
    };
}
