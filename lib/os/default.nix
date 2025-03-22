{ inputs, ... }:

let
  inherit (inputs)
    self
    nixpkgs
    nix-darwin
    sops-nix
    nur
    home-manager
    nixos-facter-modules
    udev-nix
    _1password-shell-plugins
    ;
in
rec {
  mkSystem =
    { system
    , host
    , user
    , iso ? false
    , facter ? false
    ,
    }:
    {
      inherit system;

      specialArgs = {
        inherit self inputs;
      };

      modules =
        [
          (
            { config, ... }:
            {
              nixpkgs.overlays =
                [
                  (final: prev: {
                    unstable = builtins.import inputs.unstable {
                      inherit (final) config;
                      inherit system;
                    };
                  })
                  (final: prev: {
                    master = builtins.import inputs.master {
                      inherit (final) config;
                      inherit system;
                    };
                  })
                  (final: prev: {
                    udev-nix = udev-nix.lib.${system};
                  })
                  (final: prev: builtins.import ../../overlays/packages { inherit final prev; })
                  (final: prev: builtins.import ../../overlays/patches { inherit final prev; })
                  nur.overlays.default
                ]
                ++ (nixpkgs.lib.optionals config.programs.ccache.enable [
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
                ]);
            }
          )
          nixos-facter-modules.nixosModules.facter

          ../../hosts/${host}/configuration.nix
          ../../users/${user}/configuration.nix

          home-manager.nixosModules.home-manager
          nur.modules.nixos.default
          (
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = builtins.import ../../users/${user}/home.nix;
                sharedModules = nixpkgs.lib.optionals (!iso) [
                  sops-nix.homeManagerModules.sops
                  _1password-shell-plugins.hmModules.default
                ];
              };
            }
            // (nixpkgs.lib.optionalAttrs (!iso) {
              sops = {
                defaultSopsFile = ../../secrets/default.yaml;
              };
            })
            // (nixpkgs.lib.optionalAttrs facter {
              facter.reportPath = ../../hosts/${host}/facter.json;
            })
          )
        ]
        ++ (nixpkgs.lib.optionals (!iso) [
          ../../mixins/nix
          ../../mixins
          sops-nix.nixosModules.sops
          _1password-shell-plugins.nixosModules.default
        ]);
    };

  mkNixosSystem = config: nixpkgs.lib.nixosSystem (mkSystem config);

  mkNixosSystems =
    systems:
    builtins.listToAttrs (
      builtins.map
        (system: {
          name = system.host;
          value = mkNixosSystem system;
        })
        systems
    );

  mkDarwinSystem = config: nix-darwin.lib.darwinSystem (mkSystem config);

  mkDarwinSystems =
    systems:
    builtins.listToAttrs (
      builtins.map
        (system: {
          name = system.host;
          value = mkDarwinSystem system;
        })
        systems
    );
}
