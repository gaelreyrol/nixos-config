{ lib, options, config, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.services.openssh;
  default-key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8l0V91as58J0G8USUuxqnYZH0InHK317UnTurWgkAK gael@tower";

in
{
  options.gaelreyrol.services.openssh = with types; {
    enable = mkEnableOption "Whether or not to configure OpenSSH support.";
    authorizedKeys =
      mkOption {
        type = (listOf str);
        default = [ default-key ];
        description = "The public keys to apply.";
      };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    gaelreyrol.user.extraOptions.openssh.authorizedKeys.keys = cfg.authorizedKeys;
  };
}
