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

  outputs = inputs@{ self, nixpkgs, nixos-hardware, nur, home-manager, sbomnix }:
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
      myLib = import ./lib/default.nix {
        inherit inputs nixConf;
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

        pi0 = nixpkgs.lib.nixosSystem rec {
          system = "aarch64-linux";

          specialArgs = {
            inherit self inputs;
          };

          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
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

        tower = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit self inputs;
          };

          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
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

        thinkpad = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit self inputs;
          };

          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
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
