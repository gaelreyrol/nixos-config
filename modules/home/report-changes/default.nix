{ options, config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gaelreyrol.home.report-changes;
  user = config.gaelreyrol.user.name;
in
{
  options.gaelreyrol.home.report-changes = with types; {
    enable = mkEnableOption "Whether or not to enable report-changes scripts.";
  };

  config = mkIf cfg.enable {
    home.packages = attrValues {
      inherit (pkgs) nvd nix;
    };

    home.activation.report-changes = ''
      PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
      nvd diff $(ls -dv /nix/var/nix/profiles/per-user/${user}/home-manager-*-link | tail -2) && echo 'OK' || echo 'NOK'
    '';
  };
}
