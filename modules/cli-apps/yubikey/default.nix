{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.cli-apps.yubikey;
in
{
  options.gaelreyrol.cli-apps.yubikey = with types; {
    enable = mkEnableOption "Whether or not to enable Yubikey.";
  };

  config = mkIf cfg.enable {
    services.yubikey-agent.enable = true;

    environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
    ];

    services.udev.packages = with pkgs; [ yubikey-personalization ];
  };
}
