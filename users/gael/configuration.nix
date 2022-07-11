{ config, pkgs, ... }:

{
  users.users.gael = {
    isNormalUser = true;
    description = "Gaël Reyrol";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  programs._1password-gui = {
    enable = true;
    gid = 5000;
    polkitPolicyOwners = [ "gael" ];
  };
}

