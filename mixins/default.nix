{ config, lib, pkgs, ... }:

{
  imports = [
    ./tailscale.nix
  ];

  system.stateVersion = "23.05";

  documentation.nixos.enable = false;

  boot.tmp.cleanOnBoot = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;
  networking.networkmanager.logLevel = lib.mkDefault "INFO";
  networking.networkmanager.insertNameservers = [
    # dns0.eu
    "193.110.81.0"
    "185.253.5.0"
  ];
  networking.useDHCP = lib.mkDefault true;

  systemd.services.NetworkManager-wait-online.enable = false;

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
    bat-extras.batman
    delta
    duf
    du-dust
    broot
    fd
    tealdeer
    procs
    httpie
    fish
    nixpkgs-fmt
    nix-doc
    nixdoc
    nvd
    sops
    age
    ssh-to-age
    myPkgs.shell-utils
    s3cmd
    # Requires the huge package cudatoolkit
    # nvtop
  ];

  users.defaultUserShell = pkgs.bash;

  environment.shells = with pkgs; [ fish ];

  system.activationScripts.report-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2) && echo 'OK' || echo 'NOK'
  '';
}
