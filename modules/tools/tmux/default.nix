{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.tools.tmux;
in
{
  options.gaelreyrol.tools.tmux = with types; {
    enable = mkEnableOption "Whether or not to enable tmux.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tmux ];

    programs.tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.cpu
        tmuxPlugins.tmux-fzf
      ];
    };
  };
}
