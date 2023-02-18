{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.11";

  networking.hostName = "pi0";
  networking.firewall.allowedTCPPorts = [ 8123 ];

  sdImage.compressImage = false;
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  console.keyMap = "us";

  environment.systemPackages = with pkgs; [
    raspberrypifw
    libraspberrypi
    nginx
    home-assistant
    home-assistant-cli
    mosquitto
    zigbee2mqtt
  ];

  services.home-assistant = {
    enable = true;
    config = {
      homeassistant = {
        unit_system = "metric";
        time_zone = "Europe/Paris";
        temperature_unit = "C";
      };
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

  # services.mosquitto = {
  #   enable = true;
  #   settings = {
  #     allow_anonymous = true;
  #   };
  # };

  # services.zigbee2mqtt = {
  #   enable = true;
  #   settings = {
  #     homeassistant = config.services.home-assistant.enable;
  #     permit_join = true;
  #     serial = {
  #       port = "/dev/ttyACM0";
  #     };
  #   };
  # };
}
