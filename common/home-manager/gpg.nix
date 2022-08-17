{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.home-manager.gpg;
in {
  options.custom.home-manager.gpg = {
    enable = mkEnableOption "Enable GPG";
  };

  config = mkIf cfg.enable {
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    services.gpg-agent.enableFishIntegration = true;
  };
}
