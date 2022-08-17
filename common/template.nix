{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.template;
in {
  options.custom.template = {
    enable = mkEnableOption "Enable Template";
  };

  config = mkIf cfg.enable { };
}
