{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = github:nix-community/NUR;

    recisio.url = "git+ssh://github:gaelreyrol/nixos-recisio";
    recisio.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, nur }:
    let
      nixConf = pkgs: {
        nix = {
          package = pkgs.nixFlakes;
          extraOptions = ''
            experimental-features = nix-command flakes
            plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
          '';
          gc = {
            automatic = true;
            dates = "daily";
            persistent = true;
            options = "--delete-older-than 60d";
          };
          settings.auto-optimise-store = true;
        };
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [ nur.overlay ];
      };
    in
    {
      nixosConfigurations = {
        tower = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-ssd
            ./hosts/tower/hardware-configuration.nix
            ./hosts/tower/configuration.nix
            ./users/gael/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gael = import ./users/gael/home.nix;
            }
          ];
        };
        dell = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            nixos-hardware.nixosModules.dell-precision-5530
            ./hosts/dell/hardware-configuration.nix
            ./hosts/dell/configuration.nix
            /home/gael/.config/recisio/configuration.nix
            ./users/gael/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gael = import ./users/gael/home.nix;
            }
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            nixos-hardware.nixosModules.lenovo-thinkpad-p53
            ./hosts/thinkpad/hardware-configuration.nix
            ./hosts/thinkpad/configuration.nix
            ./users/gael/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gael = import ./users/gael/home.nix;
            }
          ];
        };
      };
    };
}
