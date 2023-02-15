{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.desktop.gnome;
in
{
  options.gaelreyrol.desktop.gnome = with types; {
    enable = mkEnableOption "Whether or not to enable GNOME desktop.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xclip
      evolution-data-server
      gthumb
      gnome.nautilus
      gnome.nautilus-python
      gnome.gnome-tweaks
      gnome.dconf-editor
      gnome.gnome-themes-extra
      gnomeExtensions.user-themes
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.removable-drive-menu
      # https://github.com/kgshank/gse-sound-output-device-chooser/issues/258
      gnomeExtensions.sound-output-device-chooser
      gnomeExtensions.systemd-manager
      gnomeExtensions.system-monitor-next
    ];

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-maps
      gnome-weather
      epiphany # web browser
      geary # email reader
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      libinput.enable = true;
    };

    services.gnome.gnome-keyring.enable = true;
    services.gnome.gnome-browser-connector.enable = true;

    security.pam.services.gdm.enableGnomeKeyring = true;
    security.pam.services."gdm-password".enableGnomeKeyring = true;
    security.pam.services."gdm-launch-environment".enableGnomeKeyring = true;

    programs.dconf.enable = true;

    services.dbus.packages = with pkgs; [ dconf ];
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    xdg.autostart.enable = true;
    xdg.mime.enable = true;
    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    gaelreyrol.home = {
      extraOptions = {
        home.shellAliases = {
          pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
          pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
        };
      };
    };
  };
}
