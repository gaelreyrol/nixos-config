{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.apps._1password;
in
{
  options.gaelreyrol.apps._1password = with types; {
    enable = mkEnableOption "Whether or not to enable 1password.";
    user = mkOption {
      type = str;
      default = config.gaelreyrol.user.name;
      description = mdDoc ''
        The user that will benefit from polkit permissions.
        Check out [_1password-gui module](https://github.com/NixOS/nixpkgs/blob/nixos-22.11/nixos/modules/programs/_1password-gui.nix) for more details.
        Check out [nix.dev documentation](https://nixos.wiki/wiki/Polkit) for more details.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs._1password-gui = {
      enable = true;

      polkitPolicyOwners = [ cfg.user ];
    };
  };
}
