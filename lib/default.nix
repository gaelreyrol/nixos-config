{ inputs, ... }:

let
  inherit (inputs) self nixpkgs sops-nix nur home-manager mention;
in
rec {
  mkNixosSystem = { system, host, user, ... }: nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit self inputs;
    };

    modules = [
      ({ config, ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            unstable = import inputs.unstable {
              inherit (final) config;
              inherit system;
            };
          })
          (import ../packages)
          nur.overlay
        ];
      })

      ../common/nix
      ../hosts/common
      ../hosts/${host}/configuration.nix
      ../users/${user}/configuration.nix

      sops-nix.nixosModules.sops

      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      mention.nixosModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = builtins.import ../users/${user}/home.nix;
        home-manager.sharedModules = [
          sops-nix.homeManagerModules.sops
        ];
        sops = {
          defaultSopsFile = ../secrets/default.yaml;

          secrets = {
            tailscale_auth_key = {
              owner = "root";
              group = "root";
            };
          };
        };
      }
    ];
  };

  mkNixosSystems = systems: builtins.listToAttrs (
    builtins.map
      (system: {
        name = system.host;
        value = (mkNixosSystem system);
      })
      systems
  );
}
