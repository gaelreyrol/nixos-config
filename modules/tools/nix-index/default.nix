{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.tools.nix-index;
in
{
  options.gaelreyrol.tools.nix-index = with types; {
    enable = mkEnableOption "Whether or not to enable nix-index.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nix-index ];

    programs.nix-index = {
      enable = true;
      # TODO: Enable bash or fish based on user default shell
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = false;
      enableNushellIntegration = false;
    };
  };
}
