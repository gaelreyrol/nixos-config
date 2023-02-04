{ config, pkgs, ... }:

{
  users.users.lab = {
    isNormalUser = true;
    description = "Home Lab";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
}

