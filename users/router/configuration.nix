{ config, pkgs, ... }:

{
  users.users.router = {
    isNormalUser = true;
    description = "Home Router";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
    password = "router";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8l0V91as58J0G8USUuxqnYZH0InHK317UnTurWgkAK gael@tower"
    ];
  };
}
