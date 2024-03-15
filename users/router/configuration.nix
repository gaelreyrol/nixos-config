{ config, pkgs, ... }:

{
  users.users.router = {
    isNormalUser = true;
    description = "Home Router";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bash;
    password = "router";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8l0V91as58J0G8USUuxqnYZH0InHK317UnTurWgkAK gael@tower"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEDaOQVs/WLWCIahRTfAmolgLV2jWL6EasDM6O++rq1M gael@thinkpad"
    ];
  };
}
