{ options, config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gaelreyrol.nix;
in
{
  options.gaelreyrol.nix = with types; {
    enable = mkOption {
      type = bool;
      default = true;
      description = "Whether or not to manage nix configuration.";
    };
    package = mkOption {
      type = package;
      default = pkgs.nixFlakes;
      description = "Which nix package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nixpkgs-fmt
      nix-doc
      nix-index
    ];

    nix =
      let
        users = [ "root" config.gaelreyrol.user.name ];
      in
      {
        package = cfg.package;
        extraOptions = lib.concatStringsSep "\n" [
          ''
            experimental-features = nix-command flakes
            plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
            http-connections = 50
            warn-dirty = false
            log-lines = 50
            sandbox = relaxed
            min-free = 1073741824
            max-free = 3221225472
          ''
          (lib.optionalString (config.gaelreyrol.tools.direnv.enable) ''
            keep-outputs = true
            keep-derivations = true
          '')
        ];

        settings = {
          experimental-features = "nix-command flakes";
          http-connections = 50;
          warn-dirty = false;
          log-lines = 50;
          sandbox = "relaxed";
          min-free = 1073741824;
          max-free = 3221225472;
          auto-optimise-store = true;
          trusted-users = users;
          allowed-users = users;
        } // (lib.optionalAttrs config.gaelreyrol.tools.direnv.enable {
          keep-outputs = true;
          keep-derivations = true;
        });

        gc = {
          automatic = true;
          dates = "daily";
          persistent = true;
          options = "--delete-older-than 30d";
        };

        # flake-utils-plus
        generateRegistryFromInputs = true;
        generateNixPathFromInputs = true;
        linkInputs = true;
      };
  };
}
