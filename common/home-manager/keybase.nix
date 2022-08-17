{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.home-manager.keybase;
in {
  options.custom.home-manager.keybase = {
    enable = mkEnableOption "Enable Keybase";
  };

  config = mkIf cfg.enable {
    services.keybase.enable = true;
    services.kbfs.enable = true;
  };
}
