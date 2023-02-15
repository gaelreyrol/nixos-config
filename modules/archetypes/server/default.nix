{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.archetypes.server;
in
{
  options.gaelreyrol.archetypes.server = with types; {
    enable = mkEnableOption "Whether or not to enable the server archetype.";
  };

  config = mkIf cfg.enable {
    gaelreyrol = {
      suites = {
        common.enable = true;
      };

      system = {
        report-changes.enable = true;
        time.enable = true;
      };
    };
  };
}
