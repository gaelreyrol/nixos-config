{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.suites.desktop;
in
{
  options.gaelreyrol.suites.desktop = with types; {
    enable = mkEnableOption "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      chromium
      thunderbird
      vlc
      filezilla
      libreoffice
      spotify
      psst
      spotifyd
    ];
  };
}
