{ config, pkgs, lib, ... }:

{
  system.stateVersion = "23.05";

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "pi0";
  networking.firewall.allowedTCPPorts = [
    config.services.home-assistant.config.http.server_port
    config.services.zigbee2mqtt.settings.frontend.port
    1883 # TODO: merge config.services.mosquitto.listeners.*.port
  ];

  sdImage.compressImage = false;

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

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

  # refer to Mic92 config when modifying: https://github.com/Mic92/dotfiles/blob/main/nixos/eve/modules/home-assistant/default.nix
  services.home-assistant = {
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
      "discovery"
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
    package = pkgs.home-assistant.override {
      # https://github.com/NixOS/nixpkgs/pull/234880
      packageOverrides = self: super: {
        aiohttp = super.aiohttp.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [
            (pkgs.fetchpatch {
              url = "https://github.com/aio-libs/aiohttp/commit/7dcc235cafe0c4521bbbf92f76aecc82fee33e8b.patch";
              hash = "sha256-ZzhlE50bmA+e2XX2RH1FuWQHZIAa6Dk/hZjxPoX5t4g=";
            })
          ];
        });
        uvloop = super.uvloop.overridePythonAttrs (oldAttrs: {
          disabledTestPaths = (oldAttrs.disabledTestPaths or [ ]) ++ [
            "tests/test_regr1.py"
          ];
        });
        yarl = super.yarl.overrideAttrs (oldAttrs: rec {
          version = "1.9.2";
          src = pkgs.fetchPypi {
            inherit (oldAttrs) pname;
            inherit version;
            hash = "sha256-BKudS59YfAbYAcKr/pMXt3zfmWxlqQ1ehOzEUBCCNXE=";
          };
          disabledTests = [ ];
        });
        snitun = super.snitun.overridePythonAttrs (oldAtts: {
          doCheck = false;
        });
        zigpy-znp = super.zigpy-znp.overridePythonAttrs (oldAtts: {
          doCheck = false;
        });
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

  # TODO:
  # Configure local write user for zigbee2mqtt and remote read user for home assistant
  # Backup /var/lib/mosquitto/mosquitto.db
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
