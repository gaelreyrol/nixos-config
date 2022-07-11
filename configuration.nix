{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver = {
    layout = "fr";
    xkbVariant = "azerty";
  };

  services.printing.enable = true;
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

  users.users.gael = {
    isNormalUser = true;
    description = "Gaël Reyrol";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  fonts.fontconfig.enable = true;

  environment.systemPackages = with pkgs; [
    openssl
    vim
    wget
    curl
    git
    tmux
    jq
    xclip
    fish
    firefox
    vscodium
    vlc
    alacritty
    filezilla
    libreoffice
    gthumb
    jetbrains-mono
    jetbrains.phpstorm
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.gnome-themes-extra
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.gsconnect
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.removable-drive-menu
    dconf2nix
    nixpkgs-fmt
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services."gdm-password".enableGnomeKeyring = true;
  security.pam.services."gdm-launch-environment".enableGnomeKeyring = true;

  programs._1password-gui = {
    enable = true;
    gid = 5000;
    polkitPolicyOwners = [ "gael" ];
  };

  services.gnome.chrome-gnome-shell.enable = true;
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
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

