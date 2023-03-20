{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    usbguard
  ];

  services.usbguard = {
    enable = true;
    IPCAllowedGroups = [ "wheel" ];
  };
}