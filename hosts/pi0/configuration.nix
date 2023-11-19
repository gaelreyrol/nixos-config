{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "pi0";
    firewall = {
      enable = lib.mkDefault false;
      allowedTCPPorts = [
        config.services.home-assistant.config.http.server_port
        config.services.zigbee2mqtt.settings.frontend.port
        1883 # TODO: merge config.services.mosquitto.listeners.*.port
      ];
    };
    extraHosts = ''
      127.0.0.1 homeassistant.local
    '';
  };

  sdImage.compressImage = false;

  security.sudo.wheelNeedsPassword = false;

  console.keyMap = "us";

  environment.systemPackages = with pkgs; [
    raspberrypifw
    libraspberrypi
    # nginx
    home-assistant-cli
    mosquitto
    zigbee2mqtt
    sqlite
  ];

  systemd = {
    services."zigbee2mqtt.service".requires = [ "mosquitto.service" ];
    services."zigbee2mqtt.service".after = [ "mosquitto.service" ];
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    # refer to Mic92 config when modifying: https://github.com/Mic92/dotfiles/blob/main/nixos/eve/modules/home-assistant/default.nix
    home-assistant = {
      enable = true;
      config = {
        homeassistant = {
          name = "Home";
          latitude = "50.6400";
          longitude = "3.0769";
          elevation = "22";
          unit_system = "metric";
          temperature_unit = "C";
          country = "FR";
          time_zone = "Europe/Paris";
          currency = "EUR";
          language = "en";
          internal_url = "http://homeassistant.local:8123";
          external_url = "http://192.168.1.14:8123";
        };

        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
        logger = {
          default = "warn";
        };

        # extra
        air_quality = { };
        co2signal = {
          country_code = "FR";
        };
        discovery = { };
        esphome = { };
        http = { };
        # meteo_france = { };
        mqtt = { };
        profiler = { };
        recorder = { };
        rpi_power = { };
        season = { };
        # upnp = { };
        version = { };
        workday = { };
        zha = { };
      };
      extraComponents = [
        "air_quality"
        "co2signal"
        # "discovery"
        "esphome"
        "http"
        "meteo_france"
        "mqtt"
        "profiler"
        "recorder"
        "rpi_power"
        "season"
        "upnp"
        "version"
        "workday"
        "zha"
      ];
      extraPackages = python3Packages: with python3Packages; [
        # https://www.home-assistant.io/docs/authentication/multi-factor-auth/
        pyqrcode
        pyotp
      ];
      package = pkgs.unstable.home-assistant;
    };

    zigbee2mqtt = {
      enable = true;
      settings = {
        permit_join = true;
        serial.port = "/dev/ttyACM0";

        mqtt.server = "mqtt://localhost:1883";

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

    # TODO:
    # Configure local write user for zigbee2mqtt and remote read user for home assistant
    # Backup /var/lib/mosquitto/mosquitto.db
    mosquitto = {
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

    # nginx = {
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

  };
}
