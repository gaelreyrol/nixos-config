{ config, lib, pkgs, ... }:

with lib;

let cfg = config.template;
in {
  options.template = {
    enable = mkEnableOption "Enable Template";
  };

  config = mkIf cfg.enable {

  };
}