{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.archetypes.workstation;
in
{
  options.gaelreyrol.archetypes.workstation = with types; {
    enable = mkEnableOption "Whether or not to enable the workstation archetype.";
  };

  config = mkIf cfg.enable {
    gaelreyrol = {
      suites = {
        common.enable = true;
        desktop.enable = true;
        development.enable = true;
        social.enable = true;
      };

      apps = {
        _1password.enable = true;
        firefox.enable = true;
        keybase.enable = true;
        vscodium.enable = true;
        yubikey.enable = true;
      };

      cli-apps = {
        _1password.enable = true;
        alacritty.enable = true;
        fish.enable = true;
        keybase.enable = true;
        yubikey.enable = true;
      };

      tools = {
        direnv.enable = true;
        fzf.enable = true;
        git.enable = true;
        nix-index.enable = true;
        tmux.enable = true;
      };

      desktop = {
        gnome.enable = true;
      };

      hardware = {
        audio.enable = true;
      };

      securiry = {
        gpg = true;
      };

      services = {
        avahi.enable = true;
        printing.enable = true;
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
