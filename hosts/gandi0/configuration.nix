{ config, pkgs, lib, ... }:

let
  rootDomain = "gaelreyrol.com";
  providerDomain = "gandi0.${rootDomain}";
  cloudDomain = "cloud.${rootDomain}";
in {
  system.stateVersion = "23.05";

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "gandi0";
  networking.firewall.enable = lib.mkForce true;

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  console.keyMap = "us";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud26;
    hostName = cloudDomain;
    https = true;

    config = {
      dbtype = "pgsql";
      adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
    };

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit news contacts calendar tasks;
    };
    extraAppsEnable = true;
  };

  services.prometheus = {
    enable = true;
    listenAddress = 127.0.0.1;

    alertmanager = {
      enable = true;
      listenAddress = 127.0.0.1;
    };

    exporters = {
      blackbox = {
        enable = true;
        listenAddress = 127.0.0.1;
        configFile = "/etc/prometheus/blackbox.yaml"; # TODO: environment.etc."prometheus/blackbox.yaml".source = pkgs.writeText "blackbox.yaml" '''';
      };

      nginx = {
        enable = true;
        listenAddress = 127.0.0.1;
      };

      node = {
        enable = true;
        listenAddress = 127.0.0.1;
      };

      nextcloud = {
        enable = true;
        listenAddress = 127.0.0.1;
      };

      # With nixos-23.11
      # php-fpm = {
      #   enable = true;
      #   listenAddress = 127.0.0.1;
      # };

      postgres = {
        enable = true;
        listenAddress = 127.0.0.1;
      };

      process = {
        enable = true;
        listenAddress = 127.0.0.1;
      };

      systemd = {
        enable = true;
        listenAddress = 127.0.0.1;
      };
    };

    scrapeConfigs = [
      {
        job_name = "blackbox";
        static_configs = [{
          targets = [ "https://${cloudDomain}" ];
        }];
      }

      {
        job_name = "nginx";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.nginx.port}" ];
        }];
      }

      {
        job_name = "node";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }

      {
        job_name = "nextcloud";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.nextcloud.port}" ];
        }];
      }

      # {
      #   job_name = "php-fpm";
      #   static_configs = [{
      #     targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.php-fpm.port}" ];
      #   }];
      # }

      {
        job_name = "process";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.process.port}" ];
        }];
      }

      {
        job_name = "prometheus";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.port}" ];
        }];
      }

      {
        job_name = "scaphandre";
        static_configs = [{
          targets = [ ]; # TODO: Tailscale hosts
        }];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      analytics = {
        reporting_enabled = false;
        check_for_updates = false;
        feedback_links_enabled = false;
        check_for_plugin_updates = false;
      };

      server = {
        domain = "grafana.${rootDomain}";
      };

      database = {
        type = "postgres";
        user = "grafana";
        password = "grafana";
      };

      smtp = {
        host = "smtp-relay.sendinblue.com:587";
        user = ""; # TODO: Fetch from secrets
        password = ""; # TODO: Fetch from secrets
        from_name = "Grafana";
        from_address = "grafana@${providerDomain}";
      };

      security = {
        disable_gravatar = true;
        disable_initial_admin_creation = true;
      };
    };

    provision = {
      enable = true;
      datasources = {
        settings = {
          datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              url = ""; # TODO: Setup Prometheus
              secureJsonData = { }; # TODO: Basic Auth
            }
          ];
        };
      };
    };
  };

  services.postgresql = {
    enable = true;

    ensureDatabases = [
      "grafana"
      "nextcloud"
    ];

    ensureUsers = [
      {
        name = "grafana";
        ensurePermissions = {
          "DATABASE grafana" = "ALL PRIVILEGES";
        };
      }
      {
        name = "nextcloud";
        ensurePermissions = {
          "DATABASE nextcloud" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.nginx.virtualHosts = {
    "${config.services.nextcloud.hostName}" = {
      forceSSL = true;
      enableACME = true;
    };

    "prometheus.${rootDomain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
      };
      forceSSL = true;
      enableACME = true;
    };

    "${config.services.grafana.domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
      };
      forceSSL = true;
      enableACME = true;
    };
  };
}
