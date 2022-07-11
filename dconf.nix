# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        "appindicatorsupport@rgcjonas.gmail.com"
        "gsconnect@andyholmes.github.io"
        "trayIconsReloaded@selfmade.pl"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/shell/extensions/caffeine" = {
      user-enabled = true;
    };

  };
}
