{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gaelreyrol.security.gpg;
in
{
  options.gaelreyrol.security.gpg = with types; {
    enable = mkEnableOption "Whether or not to enable GPG.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnupg
    ];

    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      # TODO: Enable bash or fish based on user default shell
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = false;
    };
  };
}
