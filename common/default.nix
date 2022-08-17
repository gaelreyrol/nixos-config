{ config, ... }:

let globalCfg = config.custom;
in {
  config = {
    imports = [
      ./desktop
      ./home-manager
      ./programs
    ];

    services.fwupd.enable = true;

    time.timeZone = "Europe/Paris";

    i18n.defaultLocale = "en_US.UTF-8";

    # ToDo: Parametrize
    console.keyMap = "${globalCfg.locale.console}";

    networking.useDHCP = true;
    networking.networkmanager.enable = true;

    services.journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';

    system.stateVersion = "22.05";

    environment.systemPackages = with pkgs; [
      openssl
      gnumake
      wget
      curl
      ripgrep
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
      dconf2nix
      nixpkgs-fmt
      rnix-lsp
      nixdoc
      shellcheck
      checkmake
      dhall
      dhall-json
      dhall-lsp-server
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
