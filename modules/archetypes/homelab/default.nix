{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.archetypes.homelab;
in
{
  options.gaelreyrol.archetypes.homelab = with types; {
    enable = mkEnableOption "Whether or not to enable the homelab archetype.";
  };

  config = mkIf cfg.enable {
    gaelreyrol = {
      suites = {
        common.enable = true;
      };

      cli-apps = {
        fish.enable = true;
      };

      tools = {
        direnv.enable = true;
        fzf.enable = true;
        git.enable = true;
        nix-index.enable = true;
        tmux.enable = true;
      };

      securiry = {
        gpg = true;
      };

      system = {
        report-changes.enable = true;
        fonts.enable = true;
        locale.enable = true;
        network.enable = true;
        time.enable = true;
      };
    };
  };
}
