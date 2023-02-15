{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.tools.git;
  gpg = config.gaelreyrol.security.gpg;
  user = config.gaelreyrol.user;
in
{
  options.gaelreyrol.tools.git = with types; {
    enable = mkEnableOption "Whether or not to enable Git.";
    userName = mkOption {
      type = str;
      default = user.fullName;
      description = "The name to configure git with.";
    };
    userEmail = mkOption {
      type = str;
      default = user.email;
      description = "The email to configure git with.";
    };
    # TODO: Try get from elsewhere :smiling_face:
    signingKey =
      mkOption {
        type = str;
        default = "DFB9B69A2C427F61";
        description = "The key ID to sign commits with.";
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ];

    programs.git = {
      enable = true;

      inherit (cfg) userName userEmail;

      lfs.enable = true;

      signing = {
        key = cfg.signingKey;
        signByDefault = mkIf gpg.enable true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        fetch.prune = true;
        diff.colorMoved = "default";
      };
    };
  };
}
