{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.11";

  environment.systemPackages = with pkgs; [
    # https://wiki.archlinux.org/title/PC_speaker#Beep
    beep
  ];

  networking.hostName = "apu";

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  console.keyMap = "us";
}
