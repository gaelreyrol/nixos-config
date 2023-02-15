{ options, config, pkgs, lib, ... }:

with lib;

let cfg = config.gaelreyrol.services.printing;
in
{
  options.gaelreyrol.services.printing = with types; {
    enable = mkEnableOption "Whether or not to enable printing.";
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ hplipWithPlugin ];
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
  };
}
