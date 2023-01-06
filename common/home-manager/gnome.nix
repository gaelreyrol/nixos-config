{ config, lib, pkgs, ... }:

with lib;
with lib.hm.gvariant;

let cfg = config.desktop.gnome;
in {
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
        color-scheme = "default";
        locate-pointer = true;
        clock-show-date = true;
        # text-scaling-factor = 1.25;
        enable-animations = false;
      };

      "org/gnome/desktop/calendar" = {
        show-weekdate = true;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };

      "org/gnome/desktop/wm/preferences" = {
        focus-mode = "sloppy";
      };

      "org/gtk/settings/file-chooser" = {
        clock-format = "24h";
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
      };

      "org/gnome/shell" = {
        enabled-extensions = [
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "caffeine@patapon.info"
          "appindicatorsupport@rgcjonas.gmail.com"
          "gsconnect@andyholmes.github.io"
          "trayIconsReloaded@selfmade.pl"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "systemd-manager@hardpixel.eu"
          "sound-output-device-chooser@kgshank.net"
        ];
      };

      "org/gnome/shell/extensions/caffeine" = {
        user-enabled = true;
      };

      # ToDo: Add if strongswan is installed
      "org/gnome/shell/extensions/systemd-manager" = {
        command-method = "systemctl";
        systemd = [
          ''{"name":"Strongswan","service":"strongswan.service","type":"system"}''
        ];
      };
    };
  };
}
