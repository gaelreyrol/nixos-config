{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = github:nix-community/NUR;
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mention.url = "git+ssh://git@github.com/gaelreyrol/nixos-mention?ref=main";
    mention.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, pre-commit-hooks, ... }:
    let
      myLib = import ./lib/default.nix { inherit inputs; };
    in


    rec {
      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      };

      checks = {
        x86_64-linux = {
          pre-commit-check = pre-commit-hooks.lib.x86_64-linux.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
            };
          };
        };
      };

      devShells = {
        x86_64-linux = {
          default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
            inherit (self.checks.x86_64-linux.pre-commit-check) shellHook;
          };
        };
      };

      nixosConfigurations = myLib.mkNixosSystems [
        {
          system = "aarch64-linux";
          host = "pi0";
          user = "lab";
        }
        {
          system = "x86_64-linux";
          host = "apu";
          user = "lab";
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

      packages = {
        x86_64-linux = {
          pi0Image = self.nixosConfigurations.pi0.config.system.build.sdImage;
          apuImage = self.nixosConfigurations.apu.config.system.build.sdImage;
          mqttx = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/mqttx { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
        };
      };
    };
}
