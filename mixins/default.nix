{ config, lib, pkgs, ... }:

{
  imports = [
    ./tailscale.nix
  ];

  system.stateVersion = "24.11";

  documentation.nixos.enable = false;

  boot.tmp.cleanOnBoot = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    networkmanager = {
      enable = true;
      logLevel = lib.mkDefault "INFO";
      insertNameservers = [
        # dns0.eu
        "193.110.81.0"
        # quad9
        "9.9.9.9"
      ];
      settings.main.systemd-resolved = "false";
    };
    useDHCP = lib.mkDefault true;
  };

  systemd.network.wait-online.enable = lib.mkForce false;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

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
    trippy
    vim
    wget
    curl
    git
    tmux
    jq
    ripgrep
    fzf
    dogdns
    # exa
    eza
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
    nvd
    sops
    age
    ssh-to-age
    myPkgs.shell-utils
    s3cmd
    cntr
    ast-grep
    # Requires the huge package cudatoolkit
    # nvtop
    gh
    rclone
    terraform
    tflint
    teleport
    kubectl
    kubernetes-helm
    pre-commit
    commitizen
    gnumake
    unstable.nixos-facter
  ];

  users.defaultUserShell = pkgs.bash;

  environment.shells = with pkgs; [ fish ];

  system.activationScripts.report-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2) && echo 'OK' || echo 'NOK'
  '';
}
