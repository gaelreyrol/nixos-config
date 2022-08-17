{ config, lib, pkgs, ... }:

with lib;

let
  globalCfg = config.custom;
  cfg = config.custom.programs.onepassword;
in
{
  options.custom.system.onepassword = {
    enable = mkEnableOption "Enable 1Password";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      _1password
      _1password-gui
    ];
    programs._1password-gui = {
      enable = true;
      # ToDo: Parametrize
      polkitPolicyOwners = [ "${globalCfg.user.name}" ];
    };
    users.users.${globalCfg.user.name} = {
      extraGroups = [ "onepassword" "onepassword-cli" ];
    };
  };
}
