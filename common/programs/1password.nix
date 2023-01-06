{ config, lib, pkgs, ... }:

with lib;

let cfg = config.system.onepassword;
in {
  options.system.onepassword = {
    enable = mkEnableOption "Enable 1Password";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      _1password
      _1password-gui
    ];
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "gael" ];
    };
    users.users.gael = {
      extraGroups = [ "onepassword" "onepassword-cli" ];
    };
  };
}
