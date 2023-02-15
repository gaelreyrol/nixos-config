{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.suites.development;
in
{
  options.gaelreyrol.suites.development = with types; {
    enable = mkEnableOption "Whether or not to enable common development configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jetbrains.phpstorm
      insomnia
      postman
      zeal
      exercism
    ];
  };
}
