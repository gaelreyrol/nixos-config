{ config, lib, pkgs, ... }:

{
  boot.cleanTmpDir = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;
  networking.networkmanager.logLevel = "INFO";
  networking.networkmanager.insertNameservers = [
    # dns0.eu
    "193.110.81.0"
    "185.253.5.0"
  ];
  networking.useDHCP = lib.mkDefault true;

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=5day
  '';

  environment.systemPackages = with pkgs; [
    openssl
    gnumake
    pciutils
    lshw
    usbutils
    ethtool
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
    httpie
    fish
    nixpkgs-fmt
    nixdoc
    nvd
  ];

  users.defaultUserShell = pkgs.bash;

  environment.shells = with pkgs; [ fish ];

  system.activationScripts.report-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2) && echo 'OK' || echo 'NOK'
  '';
}
