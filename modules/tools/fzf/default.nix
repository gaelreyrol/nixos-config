{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.tools.fzf;
in
{
  options.gaelreyrol.tools.fzf = with types; {
    enable = mkEnableOption "Whether or not to enable fzf.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ fzf ];

    programs.fzf = {
      enable = true;
      # TODO: Enable bash or fish based on user default shell
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = false;
      # TODO: Enable if tmux is enabled
      tmux.enableShellIntegration = true;
    };
  };
}
