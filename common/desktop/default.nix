{ pkgs, lib, ... }:

with lib;
let
  globalCfg = config.custom;
  cfg = config.custom.desktop;
in
{
  options.custom.desktop = {
    enable = mkEnableOption "Enable Desktop";
  };

  config = mkIf cfg.enable {
    imports = [
      ./audio.nix
      ./bluetooth.nix
      ./chat.nix
      ./gnome.nix
    ];

    services.xserver = {
      enable = true;
      # ToDo: Parametrize
      layout = "${globalCfg.locale.layout}";
      # ToDo: Parametrize
      xkbVariant = "${globalCfg.locale.keyboard}";
    };
    services.xserver.libinput.enable = true;

    xdg.autostart.enable = true;
    xdg.mime.enable = true;
    xdg.mime.defaultApplications = mkIf cfg.custom.home-manager.firefox.enable {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    services.printing.enable = true;

    fonts.fontconfig.enable = true;

    environment.systemPackages = with pkgs; [
      xdg-utils
      xclip
      networkmanagerapplet

      jetbrains-mono

      vscodium
      jetbrains.phpstorm
      insomnia

      chromium
      thunderbird
      vlc
      filezilla
      libreoffice
      spotify

      php81
      php81Packages.composer
      symfony-cli
      nodejs
      nodePackages.npm
      nodePackages.yarn
      go

      exercism
    ];
  };
}
