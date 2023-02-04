{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  imports = [
    ../../common/activation/home-report-changes.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    BAT_THEME = "Solarized (light)";
  };

  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager

    _1password

    jetbrains-mono

    shellcheck
    checkmake
    dhall
    dhall-json
    dhall-lsp-server
  ];

  fonts.fontconfig.enable = true;

  programs.vim.enable = true;

  programs.jq.enable = true;

  programs.ssh.enable = true;

  programs.fish = {
    enable = true;
    functions =
      {
        fish_greeting = "";
      };
    shellAliases = {
      dig = "dog";
      ls = "exa";
      cat = "bat";
    };
    interactiveShellInit = ''
      if status is-interactive
      and not set -q TMUX
        tmux new-session -A -s default
      end
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.git = {
    enable = true;
    userName = "Gaël Reyrol";
    userEmail = "me@gaelreyrol.dev";
    lfs.enable = true;
    signing = {
      key = "DFB9B69A2C427F61";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      fetch.prune = true;
      diff.colorMoved = "default";
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.tmux-fzf
    ];
  };
}
