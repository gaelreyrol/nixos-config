{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "22.11";

  networking.hostName = "thinkpad";

  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:02:00:0";
  };

  hardware.bluetooth.enable = true;

  services.fwupd.enable = true;

  # gaelreyrol = {
  #   archetypes = {
  #     workstation.enable = true;
  #   };
  # };
}

