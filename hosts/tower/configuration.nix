{ config, pkgs, lib, ... }:

{
  imports = [
    ./disks.nix
    ./hardware-configuration.nix
    ../common/firmware.nix
    ../common/fonts.nix
    ../common/desktop.nix
    ../common/audio.nix
    ../common/bluetooth.nix
    ../common/printing.nix
    ../common/avahi.nix
  ];

  system.stateVersion = "22.11";

  networking.hostName = "tower";

  console.keyMap = "us";

  environment.systemPackages = with pkgs; [
    myPkgs.gnome-monitors-switch
    myPkgs.mqttx
  ];

  hardware.nvidia.prime = {
    offload.enable = false;
    nvidiaBusId = "PCI:01:00:0";
  };

  mention.enable = true;
}
