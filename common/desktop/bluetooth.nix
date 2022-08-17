{ config, lib, ... }:

with lib;
let cfg = config.custom.desktop;
in {
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
