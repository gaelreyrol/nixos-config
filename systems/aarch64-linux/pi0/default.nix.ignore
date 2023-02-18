{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "22.11";

  networking.hostName = "pi0";

  users.defaultUserShell = pkgs.bash;

  environment.systemPackages = with pkgs; [
    raspberrypifw
    libraspberrypi
    nginx
    home-assistant
    home-assistant-cli
    mosquitto
    zigbee2mqtt
  ];

  gaelreyrol = {
    user = {
      name = "homelab";
      fullName = "Personal Homelab";
    };
    archetypes = {
      homelab.enable = true;
    };
  };

  # services.nginx = {
  #   enable = true;
  #   statusPage = true;
  #   virtualHosts = {
  #     "home.local" = {
  #       forceSSL = false;
  #       enableACME = false;
  #       locations."/" = {
  #         proxyPass = "http://[::1]:8123";
  #         proxyWebsockets = true;
  #       };
  #     };
  #   };
  # };

  # services.home-assistant = {
  #   enable = true;
  #   config = {
  #     homeassistant = {
  #       unit_system = "metric";
  #       time_zone = "Europe/Paris";
  #       temperature_unit = "C";
  #     };
  #   };
  # };

  # services.mosquitto = {
  #   enable = true;
  # };

  # services.zigbee2mqtt = {
  #  enable = true;
  #   settings = {
  #     homeassistant = config.services.home-assistant.enable;
  #     permit_join = true;
  #     serial = {
  #       port = "/dev/ttyACM0";
  #     };
  #   };
  #  };
}
