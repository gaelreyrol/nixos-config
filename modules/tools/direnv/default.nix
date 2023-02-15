{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.tools.direnv;
in
{
  options.gaelreyrol.tools.direnv = with types; {
    enable = mkEnableOption "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ direnv ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      # TODO: Enable bash or fish based on user default shell
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = false;
    };
  };
}
