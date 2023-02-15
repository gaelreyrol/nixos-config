{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gaelreyrol.system.time;
in
{
  options.gaelreyrol.system.time = with types; {
    enable =
      mkEnableOption "Whether or not to configure timezone information.";
  };

  config = mkIf cfg.enable { time.timeZone = "Europe/Paris"; };
}
