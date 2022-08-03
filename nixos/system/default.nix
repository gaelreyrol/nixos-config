{ config, pkgs, lib, ... }:
let cfg = config.system;
in {
  options.system = {
    hostname = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = false;
      description = "Define system hostname";
    };
    ownerId = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Define system owner id";
      example = "gael";
    };
    ownerName = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Define system owner name";
      example = "Gaël Reyrol";
    };
  };
  config = {
    networking.hostName = mkForce "${cfg.system}";
    networking.networkmanager.enable = true;

    time.timeZone = mkForce "Europe/Paris";

    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "fr";

    services.fwupd.enable = true;
    services.udev.packages = with pkgs; [ yubikey-personalization ];

    users.defaultUserShell = pkgs.bash;

    environment.systemPackages = with pkgs; [
      openssl
      gnumake
      pciutils
      yubico-pam
      yubikey-personalization
      yubikey-manager
      vim
      wget
      curl
      git
      tmux
      xclip
      fish
      jetbrains-mono
    ];

    environment.shells = with pkgs; [ fish ];

    # security.pam.yubico = {
    #   enable = true;
    #   debug = true;
    #   control = "required";
    #   mode = "challenge-response";
    # };

    users.users.${cfg.ownerId} = {
      isNormalUser = true;
      description = "${cfg.ownerName}";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.fish;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.05"; # Did you read the comment?
  };
}
