{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.11";

  networking.hostName = "pi0";
  networking.firewall.allowedTCPPorts = [ 8123 1883 8080 ];

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
    # nginx
    home-assistant-cli
    mosquitto
    zigbee2mqtt
  ];

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

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "met"
      "bluetooth"
      "esphome"
      "profiler"
      "backup"
      "recorder"
      "dhcp"
      "air_quality"
      "http"
      "ssdp"
      "upnp"
      "calendar"
      "discovery"
      "mqtt"
      "ipp"
      "mobile_app"
      "zeroconf"
      "version"
      "season"
      "meteo_france"
      "workday"
      "rpi_power"
      "sun"
      "co2signal"
    ];
    extraPackages = python3Packages: with python3Packages; [
      # https://www.home-assistant.io/docs/authentication/multi-factor-auth/
      pyqrcode
      pyotp
    ];
    config = {
      homeassistant = {
        name = "Home";
        latitude = "50.6400";
        longitude = "3.0769";
        elevation = "22";
        unit_system = "metric";
        temperature_unit = "C";
        # country = "FR"; # 2022.12.0
        time_zone = "Europe/Paris";
        currency = "EUR";
        # language = "en-US";
        internal_url = "http://homeassistant.local:8123";
        external_url = "http://192.168.1.14:8123";
      };
      # Native
      automation = { };
      backup = { };
      bluetooth = { };
      config = { };
      counter = { };
      dhcp = { };
      energy = { };
      frontend = { };
      hardware = { };
      history = { };
      logbook = { };
      logger = { };
      map = { };
      my = { };
      mobile_app = { };
      network = { };
      person = { };
      schedule = { };
      scene = { };
      script = { };
      ssdp = { };
      sun = { };
      system_health = { };
      timer = { };
      usb = { };
      zeroconf = { };
      zone = { };
      # Extra
      mqtt = { };
      meteo_france = {
        city = "59000";
      };
      co2signal = {
        country_code = "FR";
      };
    };
  };

  networking.firewall.enable = lib.mkDefault false;

  networking.extraHosts = ''
    127.0.0.1 homeassistant.local
  '';

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      permit_join = true;
      serial.port = "/dev/ttyACM0";

      mqtt.server = "mqtt://localhost:1883";

      frontend.port = 8080;
    };
  };

  systemd.services."zigbee2mqtt.service".requires = [ "mosquitto.service" ];
  systemd.services."zigbee2mqtt.service".after = [ "mosquitto.service" ];

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
        acl = [ "topic readwrite #" "pattern readwrite #" ];
        users = { };
      }
    ];
  };
}
