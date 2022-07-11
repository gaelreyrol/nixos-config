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

  imports = [
    ./dconf.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.packages = with pkgs; [
    _1password
    _1password-gui
    keybase
    kbfs
    keybase-gui
    thunderbird
    chromium
    slack
    discord
    zoom-us
    spotify
    php81
    php81Packages.composer
    symfony-cli
    nodejs
    nodePackages.npm
    go
    postgresql_14
    dhall
    dhall-json
    exercism
  ];

  fonts.fontconfig.enable = true;

  services.keybase.enable = true;

  programs.gpg.enable = true;

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

  # programs.ssh = {
  #   enable = true;
  #   matchBlocks = {
  #     "github.com" = {
  #       extraOptions = {
  #         IdentityAgent = "~/.1password/agent.sock";
  #       };
  #     };
  #   };
  # };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "JetBrains Mono";
        size = 12.0;
      };

      colors = {
        primary = {
          background = "#fdf6e3";
          foreground = "#657b83";
        };
        cursor = {
          text = "#fdf6e3";
          curser = "#657b83";
        };
        normal = {
          black = "#073642";
          red = "#dc322f";
          green = "#859900";
          yellow = "#b58900";
          blue = "#268bd2";
          magenta = "#d33682";
          cyan = "#2aa198";
          white = "#eee8d5";
        };
        bright = {
          black = "#002b36";
          red = "#cb4b16";
          green = "#586e75";
          yellow = "#657b83";
          blue = "#839496";
          magenta = "#6c71c4";
          cyan = "#93a1a1";
          white = "#fdf6e3";
        };
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Gaël Reyrol";
    userEmail = "me@gaelreyrol.dev";
    signing = {
      key = "DFB9B69A2C427F61";
      signByDefault = true;
    };
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
