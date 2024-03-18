{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    package = pkgs.master.docker;
  };

  environment.systemPackages = [
    pkgs.master.docker-compose
  ];
}
