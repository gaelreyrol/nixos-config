{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = github:nix-community/NUR;

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


    sbomnix.url = github:tiiuae/sbomnix;
    sbomnix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      myLib = import ./lib/default.nix { inherit inputs; };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations = {
        pi0 = myLib.mkNixosSystem {
          system = "aarch64-linux";
          host = "pi0";
          user = "lab";
        };

        tower = myLib.mkNixosSystem {
          system = "x86_64-linux";
          host = "tower";
          user = "gael";
        };

        thinkpad = myLib.mkNixosSystem {
          system = "x86_64-linux";
          host = "thinkpad";
          user = "gael";
        };
      };

      packages.x86_64-linux.pi0Image = self.nixosConfigurations.pi0.config.system.build.sdImage;
    };
}
