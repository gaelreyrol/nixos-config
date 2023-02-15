{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.cli-apps.fish;
in
{
  options.gaelreyrol.cli-apps.fish = with types; {
    enable = mkEnableOption "Whether or not to enable Fish shell.";
  };

  config = mkIf cfg.enable {
    environment.shells = with pkgs; [ fish ];

    programs.fish = {
      enable = true;
      functions.fish_greeting = "";
      # TODO: Activate if tmux is enabled
      interactiveShellInit = ''
        if status is-interactive
        and not set -q TMUX
          tmux new-session -A -s default
        end
      '';
    };
  };
}
