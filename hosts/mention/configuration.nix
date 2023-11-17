{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../mixins/firmware.nix
    ../../mixins/fonts.nix
    ../../mixins/desktop.nix
    ../../mixins/audio.nix
    ../../mixins/bluetooth.nix
    ../../mixins/printing.nix
    ../../mixins/avahi.nix
    ../../mixins/docker.nix
    ../../mixins/power.nix
    ../../mixins/energy.nix
  ];

  networking.hostName = "mention";

  console.keyMap = "fr";

  services.xserver = {
    layout = "fr";
    xkbVariant = "azerty";
  };

  # Cannot use password authentication https://github.com/NixOS/nixpkgs/issues/171136
  # services.fprintd.enable = true;
  # environment.systemPackages = with pkgs; [
  #   fprintd
  # ];

  mention.enable = true;
  mention.firstname = "gael";
  mention.lastname = "reyrol";

  programs.captive-browser = {
    enable = true;
    interface = "wlp3s0";
  };

}
