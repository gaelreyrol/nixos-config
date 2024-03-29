{ config, pkgs, ... }:

{
  imports = [
    ../../mixins/activation/home-report-changes.nix
  ];

  home = {
    stateVersion = "23.11";
    sessionVariables = {
      EDITOR = "vim";
    };
    packages = with pkgs; [
      shellcheck
      checkmake
      dhall
      dhall-json
    ];
  };

  programs = {
    home-manager.enable = true;

    ssh.enable = true;
    vim.enable = true;
    jq.enable = true;

    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };

    tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.tmux-fzf
      ];
    };
  };
}
