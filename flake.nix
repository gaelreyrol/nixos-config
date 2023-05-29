{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
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

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sbomnix.url = "github:tiiuae/sbomnix";
    sbomnix.inputs.nixpkgs.follows = "unstable";

    mention.url = "git+ssh://git@github.com/gaelreyrol/nixos-mention?ref=main";
    mention.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, unstable, treefmt-nix, pre-commit-hooks, sbomnix, ... }:
    let
      myLib = import ./lib { inherit inputs; };
      forSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
        ]
          (system:
            function {
              inherit system;
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
              unstable = import unstable {
                inherit system;
                config.allowUnfree = true;
              };
            }
          );

    in
    {
      formatter = forSystems ({ pkgs, unstable, system }: treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs.nixpkgs-fmt.enable = true;
      });

      checks = forSystems ({ pkgs, unstable, system }: {
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

      devShells = forSystems ({ pkgs, unstable, system }: {
        default = pkgs.mkShell {
          packages = [
            unstable.nixpkgs-fmt
            unstable.statix
            unstable.nodePackages.markdownlint-cli
            unstable.treefmt
            unstable.editorconfig-checker
            unstable.actionlint
            pkgs.nix-tree
            pkgs.nix-du
            sbomnix.packages."${system}".sbomnix
            sbomnix.packages."${system}".vulnxscan
          ];
          inherit (self.checks."${system}".pre-commit-check) shellHook;
        };
      });

      nixosConfigurations = myLib.mkNixosSystems [
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

      packages = forSystems ({ pkgs, unstable, system }: removeAttrs (import ./packages { inherit pkgs; }) [ "fishPlugins" ]);

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
