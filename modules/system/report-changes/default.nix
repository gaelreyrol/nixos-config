{ options, config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gaelreyrol.system.report-changes;
in
{
  options.gaelreyrol.system.report-changes = with types; {
    enable = mkEnableOption "Whether or not to enable report-changes scripts.";
  };

  config = mkIf cfg.enable {
    system.environmentPackages = attrValues {
      inherit (pkgs) nvd nix;
    };

    system.activationScripts.report-changes = ''
      PATH=$PATH:${makeBinPath [ pkgs.nvd pkgs.nix ]}
      nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2) && echo 'OK' || echo 'NOK'
    '';
  };
}
