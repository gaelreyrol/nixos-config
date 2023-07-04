{ config, pkgs, lib, ... }:

{
  system.stateVersion = "23.05";

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "gandi0";
  networking.firewall.enable = lib.mkForce true;

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  console.keyMap = "us";
}
