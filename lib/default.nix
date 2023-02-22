{ inputs, ... }:

let
  inherit (inputs) self nixpkgs nur home-manager mention;
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

      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      mention.nixosModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = builtins.import ../users/${user}/home.nix;
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
