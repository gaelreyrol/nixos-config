{ lib, ... }:

with lib;
let globalCfg = config.custom;
in {
  config = {
    imports = [
      ./alacritty.nix
      ./firefox.nix
      ./fish.nix
      ./git.nix
      ./gnome.nix
      ./gpg.nix
      ./keybase.nix
      ./ssh.nix
      ./vscode.nix
    ];

    home.sessionVariables = {
      EDITOR = "vim";
      BAT_THEME = "${globalCfg.colorTheme}";
    };

    programs.vim.enable = true;

    programs.jq.enable = true;

    programs.fzf = {
      enable = true;
      enableFishIntegration = mkDefault config.custom.home-manager.fish.enable;
      tmux.enableShellIntegration = true;
    };

    programs.tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.cpu
        tmuxPlugins.tmux-fzf
      ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.nix-index = {
      enable = true;
      enableZshIntegration = false;
    };
  };
}
