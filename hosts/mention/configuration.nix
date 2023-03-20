{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/firmware.nix
    ../common/fonts.nix
    ../common/desktop.nix
    ../common/audio.nix
    ../common/bluetooth.nix
    ../common/printing.nix
    ../common/avahi.nix
    ../common/docker.nix
    ../common/power.nix
  ];

  system.stateVersion = "22.11";

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
}
