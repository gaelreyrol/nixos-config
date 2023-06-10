{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "unstable";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs.follows = "unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs-stable.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sbomnix.url = "github:tiiuae/sbomnix";
    sbomnix.inputs.nixpkgs.follows = "unstable";

    nixd.url = "github:nix-community/nixd";
    nixd.inputs.nixpkgs.follows = "unstable";

    mention.url = "git+ssh://git@github.com/gaelreyrol/nixos-mention?ref=main";
    mention.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, unstable, treefmt-nix, pre-commit-hooks, sbomnix, ... }:
    let
      myLib = import ./lib { inherit inputs; };
      config = {
        allowUnfree = true;
      };
      overlays = [
        (self: super: {
          unstable = import unstable {
            inherit (super) system;
            inherit config;
          };
        })
        (self: super: import ./overlays/packages { inherit self super; })
        (self: super: {
          sbomnix = sbomnix.packages."${super.system}";
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
            pkgs.sbomnix.sbomnix
            pkgs.sbomnix.vulnxscan
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
        }
        {
          system = "x86_64-linux";
          host = "thinkpad";
          user = "gael";
        }
        {
          system = "x86_64-linux";
          host = "mention";
          user = "gael";
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
