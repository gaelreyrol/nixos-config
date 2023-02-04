{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = github:nix-community/NUR;
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, nur }:
    let
      nixConf = pkgs: {
        nix = {
          package = pkgs.nixVersions.unstable;
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
      userConf = {
        name = "gael";
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      devShells.x86_64-linux = {
        default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
          name = "gael-on-x86_64-linux-system";

          packages = builtins.attrValues {

            inherit
              (nixpkgs.legacyPackages.x86_64-linux)
              gnumake
              nvd
              scc
              vim
              git
              nix
              nixos-rebuild
              cargo
              rustc
              nixos-generators
              ;
            inherit (home-manager.packages.x86_64-linux) home-manager;
          };
        };
      };

      nixosConfigurations = {
        pi0 = nixpkgs.lib.nixosSystem rec {
          system = "aarch64-linux";
          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
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

        tower = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-nvidia
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-ssd
            ./hosts/tower/hardware-configuration.nix
            ./hosts/tower/configuration.nix
            ./users/${userConf.name}/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            ./common/activation/system-report-changes.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${userConf.name} = builtins.import ./users/${userConf.name}/home.nix;
            }
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            nixos-hardware.nixosModules.lenovo-thinkpad-p53
            nixos-hardware.nixosModules.common-gpu-nvidia
            ./hosts/thinkpad/hardware-configuration.nix
            ./hosts/thinkpad/configuration.nix
            ./users/${userConf.name}/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            ./common/activation/system-report-changes.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${userConf.name} = builtins.import ./users/${userConf.name}/home.nix;
            }
          ];
        };
      };
    };
}
