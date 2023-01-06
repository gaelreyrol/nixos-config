{ config, lib, pkgs, ... }:

with lib;

let cfg = config.system.fish;
in {
  options.system.fish = {
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
        pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
        pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
        code = "${pkgs.vscodium}/bin/codium";
        dig = "dog";
        ls = "exa";
        cat = "bat";
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
