{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = github:nix-community/NUR;

    recisio.url = "git+ssh://git@github.com/gaelreyrol/nixos-recisio";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, nur, recisio }:
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
        nixpkgs.hostPlatform = "x86_64-linux";
      };
      userConf = {
        name = "gael";
        description = "Gaël Reyrol";
        email = "me@gaelreyrol.com";
      };
      devices = {
        tower = {
          system = "x86_64-linux";
          desktop.enable = true;
          recisio.enable = true;
        };
        thinkpad = {
          system = "x86_64-linux";
          desktop.enable = true;
          recisio.enable = true;
        };
        dell = {
          system = "x86_64-linux";
          desktop.enable = true;
          recisio.enable = true;
        };
      };
      recisioConf = {
        user = builtins.getEnv "RECISIO_USER";
        password = builtins.getEnv "RECISIO_PASSWORD";
      };
    in
    {
      devShells = {
        ${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
          name = "gael-on-${system}-system";

          packages = builtins.attrValues {
            inherit
              (nixpkgs.legacyPackages.${system})
              gnumake
              nvd
              scc
              vim
              git
              nix
              nixos-rebuild
              cargo
              rustc
              ;
            inherit (home-manager.packages.${system}) home-manager;
          };
        };
      };

      nixosConfigurations = {
        tower = nixpkgs.lib.nixosSystem rec {
          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-nvidia
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-ssd
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            recisio.nixosModules.default
            ./common/activation/system-report-changes.nix
            {
              recisio = userConf.recisio // {
                enable = true;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${userConf.name} = builtins.import ./users/${userConf.name}/home.nix;
            }
          ];
        };
        dell = nixpkgs.lib.nixosSystem rec {
          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            nixos-hardware.nixosModules.dell-precision-5530
            nixos-hardware.nixosModules.common-gpu-nvidia
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            recisio.nixosModules.default
            ./common/activation/system-report-changes.nix
            {
              recisio = userConf.recisio // {
                enable = true;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${userConf.name} = builtins.import ./users/${userConf.name}/home.nix;
            }
          ];
        };

        thinkpad = nixpkgs.lib.nixosSystem rec {
          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            nixos-hardware.nixosModules.lenovo-thinkpad-p53
            nixos-hardware.nixosModules.common-gpu-nvidia
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
