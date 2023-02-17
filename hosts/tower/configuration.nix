{ config, pkgs, lib, ... }:

{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?}

  networking.hostName = "tower";
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [
    # dns0.eu
    "193.110.81.0"
    "185.253.5.0"
  ];

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=5day
  '';

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  services.xserver.enable = true;

  hardware.nvidia.prime = {
    offload.enable = false;
    nvidiaBusId = "PCI:01:00:0";
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  hardware.bluetooth.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.fwupd.enable = true;

  users.defaultUserShell = pkgs.bash;

  fonts.fontconfig.enable = true;

  environment.systemPackages = with pkgs; [
    openssl
    gnumake
    pciutils
    yubico-pam
    xdg-utils
    vim
    wget
    curl
    git
    tmux
    zellij
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
    httpie
    xclip
    fish
    alacritty
    evolution-data-server
    gthumb
    gnome.nautilus
    gnome.nautilus-python
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.gnome-themes-extra
    gnomeExtensions.user-themes
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.removable-drive-menu
    # https://github.com/kgshank/gse-sound-output-device-chooser/issues/258
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.systemd-manager
    gnomeExtensions.system-monitor-next
    dconf2nix
    nixpkgs-fmt
    nixdoc
    nvd
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services."gdm-password".enableGnomeKeyring = true;
  security.pam.services."gdm-launch-environment".enableGnomeKeyring = true;

  services.gnome.gnome-browser-connector.enable = true;
  programs.dconf.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-maps
    gnome-weather
    epiphany # web browser
    geary # email reader
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  services.dbus.packages = with pkgs; [ dconf ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon yubikey-personalization ];

  xdg.autostart.enable = true;
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };

  environment.shells = with pkgs; [ fish ];
}

