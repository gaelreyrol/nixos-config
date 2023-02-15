# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
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
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "systemd-manager@hardpixel.eu"
        # "sound-output-device-chooser@kgshank.net"
        "system-monitor-next@paradoxxx.zero.gmail.com"
      ];
    };

    "org/gnome/shell/extensions/caffeine" = {
      user-enabled = true;
      show-indicator = "always";
    };

    "org/gnome/shell/extensions/systemd-manager" = {
      command-method = "systemctl";
      systemd = [ ];
    };
  };
}
