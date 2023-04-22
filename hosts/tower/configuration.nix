{ config, pkgs, lib, ... }:

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
  ];

  system.stateVersion = "22.11";

  networking.hostName = "tower";

  console.keyMap = "us";

  environment.systemPackages = with pkgs; [
    myPkgs.gnome-monitors-switch
    myPkgs.mqttx
    myPkgs.ledger-live-desktop
  ];

  services.udev.packages = with pkgs; [ myPkgs.ledger-live-desktop ];

  hardware.nvidia.prime = {
    offload.enable = false;
    nvidiaBusId = "PCI:01:00:0";
  };

  mention.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "gael" ];
}
