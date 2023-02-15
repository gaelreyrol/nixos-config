{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "22.11";

  networking.hostName = "tower";

  hardware.nvidia.prime = {
    offload.enable = false;
    nvidiaBusId = "PCI:01:00:0";
  };

  hardware.bluetooth.enable = true;

  services.fwupd.enable = true;

  gaelreyrol = {
    archetypes = {
      workstation = true;
    };
  };
}

