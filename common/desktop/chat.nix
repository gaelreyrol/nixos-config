{ config, lib, pkgs, ... }:

with lib;
let cfg = config.custom.desktop.chat;
in {
  options.custom.desktop.chat = {
    enable = mkEnableOption "Enable Chat";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
      discord
      zoom-us
      fractal
    ];
  };
}
