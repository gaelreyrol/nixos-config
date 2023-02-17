{ config, pkgs, lib, ... }:

{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  sdImage.compressImage = false;

  networking.hostName = "pi0";
  networking.nameservers = [
    # dns0.eu
    "193.110.81.0"
    "185.253.5.0"
  ];

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=5day
  '';

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  users.defaultUserShell = pkgs.bash;

  fonts.fontconfig.enable = true;

  environment.systemPackages = with pkgs; [
    raspberrypifw
    libraspberrypi
    openssl
    gnumake
    pciutils
    yubico-pam
    vim
    wget
    curl
    git
    tmux
    jq
    ripgrep
    fzf
    dogdns
    exa
    bat
    delta
    duf
    broot
    fd
    tldr
    procs
    fish
    nixpkgs-fmt
    nixdoc
    nvd
    nginx
    home-assistant
    home-assistant-cli
    mosquitto
    zigbee2mqtt
  ];

  environment.shells = with pkgs; [ fish ];

  services.nginx = {
    enable = true;
    statusPage = true;
    virtualHosts = {
      "home.local" = {
        forceSSL = false;
        enableACME = false;
        locations."/" = {
          proxyPass = "http://[::1]:8123";
          proxyWebsockets = true;
        };
      };
    };
  };

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
