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
  ];

  system.stateVersion = "22.11";

  networking.hostName = "mention";

  console.keyMap = "fr";

  # hardware.nvidia.prime = {
  #   offload.enable = true;
  #   intelBusId = "PCI:00:02:0";
  #   nvidiaBusId = "PCI:02:00:0";
  # };

  services.xserver = {
    layout = "fr";
    xkbVariant = "azerty";
  };
}
