{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  imports = [
    ../../common/activation/home-report-changes.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.packages = with pkgs; [
    shellcheck
    checkmake
    dhall
    dhall-json
  ];

  programs.vim.enable = true;

  programs.jq.enable = true;

  programs.ssh.enable = true;

  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.tmux-fzf
    ];
  };
}
