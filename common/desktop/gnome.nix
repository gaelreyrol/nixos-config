{ config, pkgs, lib, ... }:

with lib;
let cfg = config.custom.desktop;
in {
  config = mkIf cfg.enable {

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    services.gnome.gnome-keyring.enable = true;
    services.gnome.chrome-gnome-shell.enable = true;

    security.pam.services.gdm.enableGnomeKeyring = true;
    security.pam.services."gdm-password".enableGnomeKeyring = true;
    security.pam.services."gdm-launch-environment".enableGnomeKeyring = true;

    services.dbus.packages = with pkgs; [ dconf ];
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      xdg-utils
      evolution-data-server
      gthumb
      gnome.nautilus
      gnome.nautilus-python
      gnome.gnome-tweaks
      gnome.dconf-editor
      gnome.gnome-themes-extra
      gnomeExtensions.user-themes
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.gsconnect
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.sound-output-device-chooser
      gnomeExtensions.systemd-manager
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
  };
}
