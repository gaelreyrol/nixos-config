{ config, pkgs, ... }:

{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.packages = with pkgs; [
    _1password
    _1password-gui
    thunderbird
    chromium
    slack
    discord
    zoom-us
    spotify
    php81
    php81Packages.composer
    nodejs
    nodePackages.npm
    postgresql_14
    dhall
    dhall-json
  ];

  programs.vim.enable = true;

  programs.jq.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        # Gnome shell native connector
        enableGnomeExtensions = true;
      };
    };
    profiles.default = {
      id = 0;
      settings = {
        "services.sync.username" = "me@gaelreyrol.com";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock"
        }
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Gaël Reyrol";
    userEmail = "me@gaelreyrol.dev";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
    userSettings = {
      "workbench.colorTheme" = "Solarized Light";
    };
  };
}
