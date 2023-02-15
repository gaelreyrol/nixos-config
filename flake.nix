{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = github:nix-community/NUR;

    sbomnix.url = github:tiiuae/sbomnix;
    sbomnix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, nur, sbomnix }:
    let
      nixConf = pkgs: {
        nix = {
          package = pkgs.nixFlakes;
          extraOptions = ''
            experimental-features = nix-command flakes
            plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
            min-free = 1073741824
            max-free = 3221225472
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
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      devShells.x86_64-linux = {
        default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
          packages = builtins.attrValues {
            inherit
              (nixpkgs.legacyPackages.x86_64-linux)
              nixos-generators
              vulnix
              ;
            inherit (home-manager.packages.x86_64-linux) home-manager;
            inherit (sbomnix.packages.x86_64-linux) sbomnix;
          };
        };
      };

      nixosConfigurations = {
        pi0 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            (nixConf nixpkgs.legacyPackages.aarch64-linux)
            ./hosts/pi0/hardware-configuration.nix
            ./hosts/pi0/configuration.nix
            ./users/lab/configuration.nix
            home-manager.nixosModules.home-manager
            ./common/activation/system-report-changes.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lab = builtins.import ./users/lab/home.nix;
            }
          ];
        };

        tower = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (nixConf nixpkgs.legacyPackages.x86_64-linux)
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-nvidia
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-ssd
            ./hosts/tower/hardware-configuration.nix
            ./hosts/tower/configuration.nix
            ./users/gael/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            ./common/activation/system-report-changes.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gael = builtins.import ./users/gael/home.nix;
            }
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (nixConf nixpkgs.legacyPackages.x86_64-linux)
            nixos-hardware.nixosModules.lenovo-thinkpad-p53
            nixos-hardware.nixosModules.common-gpu-nvidia
            ./hosts/thinkpad/hardware-configuration.nix
            ./hosts/thinkpad/configuration.nix
            ./users/gael/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            ./common/activation/system-report-changes.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gael = builtins.import ./users/gael/home.nix;
            }
          ];
        };
      };

      packages.x86_64-linux.piImage = self.nixosConfigurations.pi0.config.system.build.sdImage;
    };
}
