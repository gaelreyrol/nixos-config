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
      show-battery-percentage = true;
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
        "appindicatorsupport@rgcjonas.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        "systemd-manager@hardpixel.eu"
        "gTile@vibou"
        "wireless-hid@chlumskyvaclav.gmail.com"
        "no-overview@fthx"
        "thinkpadthermal@moonlight.drive.vk.gmail.com"
        "tailscale-status@maxgallup.github.com"
        "eepresetselector@ulville.github.io"
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

# From https://github.com/sebastian-de/easyeffects-thinkpad-unsuck
# /com/github/wwmm/easyeffects/streamoutputs/plugins
#   ['filter#0', 'bass_enhancer#0', 'multiband_compressor#0', 'stereo_tools#0', 'limiter#0']

# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/sidechain-input-device
#   'alsa_input.pci-0000_07_00.6.HiFi__hw_Generic_1__source'

# /com/github/wwmm/easyeffects/streamoutputs/limiter/0/sidechain-input-device
#   'alsa_input.pci-0000_07_00.6.HiFi__hw_Generic_1__source'

# /com/github/wwmm/easyeffects/streamoutputs/bassenhancer/0/amount
#   22.0
# /com/github/wwmm/easyeffects/streamoutputs/bassenhancer/0/floor
#   10.0
# /com/github/wwmm/easyeffects/streamoutputs/bassenhancer/0/floor-active
#   true
# /com/github/wwmm/easyeffects/streamoutputs/bassenhancer/0/harmonics
#   9.9999999999999947
# /com/github/wwmm/easyeffects/streamoutputs/bassenhancer/0/output-gain
#   -8.0
# /com/github/wwmm/easyeffects/streamoutputs/bassenhancer/0/scope
#   200.0
# /com/github/wwmm/easyeffects/streamoutputs/blocklist
#   @as []
# /com/github/wwmm/easyeffects/streamoutputs/filter/0/frequency
#   140.0

# /com/github/wwmm/easyeffects/streamoutputs/limiter/0/attack
#   2.0
# /com/github/wwmm/easyeffects/streamoutputs/limiter/0/gain-boost
#   false
# /com/github/wwmm/easyeffects/streamoutputs/limiter/0/lookahead
#   4.0000000000000213
# /com/github/wwmm/easyeffects/streamoutputs/limiter/0/oversampling
#   'Half x4(3L)'
# /com/github/wwmm/easyeffects/streamoutputs/limiter/0/release
#   8.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/attack-threshold0
#   -16.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/attack-threshold1
#   -24.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/attack-threshold2
#   -24.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/attack-threshold3
#   -24.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/attack-time0
#   150.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/attack-time1
#   150.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/attack-time2
#   100.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/attack-time3
#   80.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/knee0
#   -12.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/knee1
#   -9.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/knee2
#   -9.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/knee3
#   -9.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/makeup0
#   4.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/makeup1
#   3.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/makeup2
#   3.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/makeup3
#   4.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/ratio0
#   5.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/ratio1
#   3.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/ratio2
#   3.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/ratio3
#   4.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/release-time0
#   300.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/release-time1
#   200.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/release-time2
#   150.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/release-time3
#   120.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/split-frequency1
#   250.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/split-frequency2
#   1250.0
# /com/github/wwmm/easyeffects/streamoutputs/multibandcompressor/0/split-frequency3
#   5000.0
# /com/github/wwmm/easyeffects/streamoutputs/stereotools/0/stereo-base
#   0.30000000000000004
# /com/github/wwmm/easyeffects/last-used-output-preset
#   'thinkpad-unsuck'
