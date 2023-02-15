{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.apps.keybase;
in
{
  options.gaelreyrol.apps.keybase = with types; {
    enable = mkEnableOption "Whether or not to enable Keybase.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      keybase-gui
    ];
  };
}
