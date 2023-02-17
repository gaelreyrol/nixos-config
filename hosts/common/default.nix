{ config, lib, pkgs, ... }:

{
  imports = [
    ../../common/activation
  ];

  boot.cleanTmpDir = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = config.system.name;
  networking.networkmanager.enable = true;
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
  ];

  users.defaultUserShell = pkgs.bash;

  environment.shells = with pkgs; [ fish ];
}
