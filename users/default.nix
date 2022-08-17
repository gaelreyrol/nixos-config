{ config, pkgs, ... }:

let globalCfg = config.options.custom;
in {
  users.defaultUserShell = pkgs.bash;

  users.users.${globalCfg.user.name} = {
    isNormalUser = true;
    description = "${globalCfg.user.description}";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  environment.shells = with pkgs; [ fish ];
}

