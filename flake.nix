{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    nur.url = "github:nix-community/NUR";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "unstable";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    udev-nix = {
      url = "github:gaelreyrol/udev-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstable.follows = "unstable";
    };

    _1password-shell-plugins = {
      url = "github:1Password/shell-plugins";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, unstable, treefmt-nix, pre-commit-hooks, udev-nix, ... }:
    let
      myLib = import ./lib { inherit inputs; };
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
        (final: prev: import ./overlays/packages { inherit final prev; })
      ];
      forSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
        ]
          (system:
            function {
              inherit system;
              pkgs = import nixpkgs {
                inherit overlays system config;
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
            pkgs.unstable.nixpkgs-fmt
            pkgs.unstable.statix
            pkgs.unstable.nodePackages.markdownlint-cli
            pkgs.unstable.editorconfig-checker
            pkgs.unstable.actionlint
            pkgs.nix-tree
            pkgs.nix-du
          ];
          inherit (self.checks."${system}".pre-commit-check) shellHook;
        };
      });

      nixosConfigurations = myLib.os.mkNixosSystems [
        {
          system = "aarch64-linux";
          host = "pi0";
          user = "lab";
        }
        {
          system = "x86_64-linux";
          host = "apu";
          user = "router";
        }
        {
          system = "x86_64-linux";
          host = "tower";
          user = "gael";
          facter = true;
        }
        {
          system = "x86_64-linux";
          host = "thinkpad";
          user = "gael";
          facter = true;
        }
        {
          system = "x86_64-linux";
          host = "iso";
          user = "nixos";
          iso = true;
        }
      ];

      packages = forSystems ({ pkgs, system }: pkgs.myPkgs);

      templates = {
        trivial = {
          path = ./templates/trivial;
          description = "A trivial but enhanced flake";
        };
        php = {
          path = ./templates/php;
          description = "A php flake";
        };
        default = self.templates.trivial;
      };
    };
}
