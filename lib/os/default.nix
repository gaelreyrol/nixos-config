{ inputs, ... }:

let
  inherit (inputs) self nixpkgs sops-nix nur home-manager udev-nix mention;
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
            unstable = builtins.import inputs.unstable {
              inherit (final) config;
              inherit system;
            };
          })
          (final: prev: {
            udev-nix = udev-nix.lib.${system};
          })
          (final: prev: builtins.import ../../overlays/packages { inherit final prev; })
          (final: prev: builtins.import ../../overlays/patches { inherit final prev; })
          nur.overlay
        ] ++ (nixpkgs.lib.optionals config.programs.ccache.enable [
          (self: super: {
            ccacheWrapper = super.ccacheWrapper.override {
              extraConfig = ''
                # https://nixos.wiki/wiki/CCache
                export CCACHE_COMPRESS=1
                export CCACHE_DIR="${config.programs.ccache.cacheDir}"
                export CCACHE_UMASK=007
              '';
            };
          })
        ]
        );
      })

      ../../mixins/nix
      ../../mixins
      ../../hosts/${host}/configuration.nix
      ../../users/${user}/configuration.nix

      sops-nix.nixosModules.sops

      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      mention.nixosModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = builtins.import ../../users/${user}/home.nix;
        home-manager.sharedModules = [
          sops-nix.homeManagerModules.sops
        ];
        sops = {
          defaultSopsFile = ../../secrets/default.yaml;
        };
      }
    ];
  };

  mkNixosSystems = systems: builtins.listToAttrs (
    builtins.map
      (system: {
        name = system.host;
        value = mkNixosSystem system;
      })
      systems
  );
}
