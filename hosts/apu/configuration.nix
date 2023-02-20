{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.11";

  networking.hostName = "apu";

  sdImage.compressImage = false;

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  console.keyMap = "us";

  services.home-assistant = {
    enable = true;
    config = {
      homeassistant = {
        unit_system = "metric";
        time_zone = "Europe/Paris";
        temperature_unit = "C";
      };
    };
  };
}
