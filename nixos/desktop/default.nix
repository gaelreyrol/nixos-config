{ config, pkgs, lib, ... }:

{
  config = {
    security.rtkit.enable = true;
    services.printing.enable = true;

    hardware.bluetooth.enable = true;
    hardware.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.xserver = {
      enable = true;
      layout = "us,fr";
      xkbVariant = "qwerty,azerty";
      libinput.enable = true;
    };

    xdg.autostart.enable = true;
    xdg.mime.enable = true;
    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    fonts.fontconfig.enable = true;

    environment.systemPackages = with pkgs; [
      yubikey-manager-qt
      yubikey-personalization-gui
      _1password-gui
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
    ];

    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ config.system.owner ];
    };
  };
}
