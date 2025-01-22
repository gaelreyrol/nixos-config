{ config, pkgs, ... }:

let
  gdmHome = config.users.users.gdm.home;
  defaultMonitors = pkgs.myPkgs.gnome-monitors-switch + "/workstation.xml";
in
{
  services = {
    libinput.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    gnome.gnome-browser-connector.enable = true;
  };

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
    evolution-data-server
    gthumb
    desktop-file-utils
    easyeffects

    # gnome
    nautilus
    nautilus-python
    gnome-tweaks
    dconf-editor
    gnome-themes-extra

    gnomeExtensions.user-themes
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.removable-drive-menu
    # gnomeExtensions.audio-output-switcher # incompatible version
    gnomeExtensions.sound-output-device-chooser # incompatible version
    gnomeExtensions.systemd-manager
    # gnomeExtensions.big-avatar # incompatible version
    gnomeExtensions.no-overview
    gnomeExtensions.wireless-hid
    gnomeExtensions.gtile
    gnomeExtensions.thinkpad-thermal
    # gnomeExtensions.nano-system-monitor # incompatible version TODO: Only for tower
    gnomeExtensions.tailscale-status
    gnomeExtensions.easyeffects-preset-selector
  ];

  security.pam.services = {
    gdm.enableGnomeKeyring = true;
    "gdm-password".enableGnomeKeyring = true;
    "gdm-launch-environment".enableGnomeKeyring = true;
  };

  programs.dconf.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs; [
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
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  xdg = {
    autostart.enable = true;
    mime = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
  };
}
