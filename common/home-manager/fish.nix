{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.home-manager.fish;
in {
  options.custom.home-manager.fish = {
    enable = mkEnableOption "Enable Fish";
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      functions =
        {
          fish_greeting = "";
        };
      shellAliases = {
        # ToDo: Define if desktop is enabled
        pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
        pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
        # ToDo: Define if vscode is enabled
        code = "${pkgs.vscodium}/bin/codium";
        dig = "dog";
        ls = "exa";
        cat = "bat";
        # ToDo: Define if recisio is configured
        office = "${pkgs.openssh}/bin/ssh dev.gael.office";
      };
      interactiveShellInit = ''
        if status is-interactive
        and not set -q TMUX
          tmux new-session -A -s default
        end
      '';
    };
  };
}
