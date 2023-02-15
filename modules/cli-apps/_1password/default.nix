{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.cli-apps._1password;
in
{
  options.gaelreyrol.cli-apps._1password = with types; {
    enable = mkEnableOption "Whether or not to enable 1password.";
  };

  config = mkIf cfg.enable {
    gaelreyrol.user.extraGroups = [ "onepassword" "onepassword-cli" ];

    programs._1password = true;
  };
}
