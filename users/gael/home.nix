{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.stateVersion = "22.05";

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

    chromium

    slack
    discord
    zoom-us

    thunderbird
    vlc
    filezilla
    libreoffice
    spotify

    jetbrains-mono

    vscodium
    jetbrains.phpstorm

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
  services.kbfs.enable = true;

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.enableFishIntegration = true;

  programs.vim.enable = true;

  programs.jq.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
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
  #         https://1password.community/discussion/121912/keyring-isnt-suid-on-nixos
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

  programs.fish.enable = true;
  programs.fish.shellAliases = {
    pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
    pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
    code = "${pkgs.vscodium}/bin/codium";
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
    # https://github.com/nix-community/home-manager/issues/2798
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
    userSettings = {
      "workbench.colorTheme" = "Solarized Light";
      "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontSize" = 16;
    };
  };
}
