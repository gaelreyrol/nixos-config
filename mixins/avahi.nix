{ config, pkgs, ... }:

{
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
}
