{ options, config, pkgs, lib, ... }:

with lib;

let cfg = config.gaelreyrol.services.avahi;
in
{
  options.gaelreyrol.services.avahi = with types; {
    enable = mkEnableOption "Whether or not to enable avahi.";
  };

  config = mkIf cfg.enable {
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
  };
}
