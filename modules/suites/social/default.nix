{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.suites.social;
in
{
  options.gaelreyrol.suites.social = with types; {
    enable = mkEnableOption "Whether or not to enable common social configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      slack
      discord
      zoom-us
      fractal
      element-desktop
      signal-desktop
    ];
  };
}
