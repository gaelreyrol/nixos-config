{ config, pkgs, ... }:

let
  gdmHome = config.users.users.gdm.home;
  defaultMonitors = pkgs.myPkgs.gnome-monitors-switch + "/workstation.xml";
in
{
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # https://wiki.archlinux.org/title/GDM#Setup_default_monitor_settings
  # https://wiki.archlinux.org/title/systemd#systemd-tmpfiles_-_temporary_files
  systemd.tmpfiles.rules = [
    "d ${gdmHome}/.config 0711 gdm gdm"
    "L+ ${gdmHome}/.config/monitors.xml - - - - ${defaultMonitors}"
  ];

  environment.systemPackages = with pkgs; [
    dconf2nix
    xdg-utils
    xclip
    alacritty
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
    gnomeExtensions.audio-output-switcher # incompatible version
    gnomeExtensions.sound-output-device-chooser # incompatible version
    gnomeExtensions.systemd-manager
    gnomeExtensions.big-avatar # incompatible version
    gnomeExtensions.no-overview
    gnomeExtensions.wireless-hid
    gnomeExtensions.gtile
    gnomeExtensions.thinkpad-thermal
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services."gdm-password".enableGnomeKeyring = true;
  security.pam.services."gdm-launch-environment".enableGnomeKeyring = true;

  services.gnome.gnome-browser-connector.enable = true;
  programs.dconf.enable = true;

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
}
