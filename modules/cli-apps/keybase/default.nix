{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.cli-apps.keybase;
in
{
  options.gaelreyrol.cli-apps.keybase = with types; {
    enable = mkEnableOption "Whether or not to enable Keybase.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      keybase
      kbfs
    ];
    services.keybase.enable = true;
    services.kbfs.enable = true;
  };
}
