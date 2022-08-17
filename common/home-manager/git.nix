{ config, lib, pkgs, ... }:

with lib;

let
  globalCfg = config.custom;
  cfg = config.custom.home-manager.git;
in
{
  options.custom.home-manager.git = {
    enable = mkEnableOption "Enable Git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      # ToDo: Parametrize
      userName = "Gaël Reyrol";
      userEmail = "me@gaelreyrol.dev";
      signing = {
        key = "DFB9B69A2C427F61";
        signByDefault = true;
      };
      includes = [
        {
          # ToDo: Configure if recisio is enabled
          condition = "gitdir:/home/gael/dev/recisio/";
          contents = {
            user = {
              email = "gael@recisio.com";
              name = "Gaël Reyrol";
              signingKey = "273123EAC37D2A99";
            };
            commit = {
              gpgSign = true;
            };
          };
        }
      ];

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        fetch.prune = true;
        diff.colorMoved = "default";
      };
    };
  };
}
