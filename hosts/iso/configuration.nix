{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  console.keyMap = "fr";

  environment.systemPackages = [
    pkgs.fwupd
    pkgs.lshw
    pkgs.tmux
  ];
}
