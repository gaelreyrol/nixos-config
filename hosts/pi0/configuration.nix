{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.11";

  networking.hostName = "pi0";
  networking.firewall.allowedTCPPorts = [
    config.services.home-assistant.config.http.server_port
    config.services.zigbee2mqtt.settings.frontend.port
    # TODO: merge config.services.mosquitto.listeners.*.port
  ];

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
      mqtt = {
        username = "hass";
        password = "!secret mqtt_password";
        discovery = true;
      };
      meteo_france = {
        city = "59000";
      };
      co2signal = {
        api_key = "!secret co2signal_token";
        country_code = "FR";
      };
      waqi = {
        token = "!secret waqi_token";
        locations = [ "Lille Leeds, France" ];
      };
    };
  };

  sops.secrets."home-assistant-secrets.yaml" = {
    owner = "hass";
    path = "/var/lib/hass/secrets.yaml";
    restartUnits = [ "home-assistant.service" ];
  };

  networking.firewall.enable = lib.mkDefault false;

  networking.extraHosts = ''
    127.0.0.1 homeassistant.local
  '';

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d4", SYMLINK+="zbdongle", MODE="0660", GROUP="zigbee2mqtt"
  '';

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = config.services.home-assistant.enable;
      availability = true;
      permit_join = true;
      serial.port = "/dev/zbdongle";

      mqtt.server = "mqtt://localhost:1883";
      mqtt.user = "zigbee2mqtt";
      mqtt.password = "!secrets.yaml mqtt_password";

      frontend.port = 8080;

      devices = {
        # Documentation: https://www.zigbee2mqtt.io/devices/ZLinky_TIC.html
        "0x00158d000966cc70" = {
          friendly_name = "LiXee ZLinky";
          description = "This device is connected to my electric meter called Linky.";
          measurement_poll_interval = 60;
          linky_mode = "auto";
          energy_phase = "auto";
          production = "auto";
          tarif = "auto";
          kWh_precision = 3;
          measurement_poll_chunk = 1;
          tic_command_whitelist = "all";
        };
      };
    };
  };

  systemd.services."zigbee2mqtt.service".requires = [ "mosquitto.service" ];
  systemd.services."zigbee2mqtt.service".after = [ "mosquitto.service" ];

  sops.secrets."zigbee2mqtt-secrets.yaml" = {
    owner = "zigbee2mqtt";
    path = "/var/lib/zigbee2mqtt/secrets.yaml";
    restartUnits = [ "zigbee2mqtt.service" ];
  };

  # TODO:
  # Backup /var/lib/mosquitto/mosquitto.db
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          hass = {
            acl = [
              "topic read zigbee2mqtt/#"
              "topic readwrite homeassistant/#"
            ];
            passwordFile = config.sops.secrets."home-assistant-secrets.yaml".mqtt_password.path;
          };
          zigbee2mqtt = {
            acl = [
              "topic write zigbee2mqtt/#"
            ];
            passwordFile = config.sops.secrets."zigbee2mqtt-secrets.yaml".mqtt_password.path;
          };
        };
      }
    ];
  };
}
