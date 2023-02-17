{ config, pkgs, ... }:

{
  imports = [
    ../../common/activation
  ];

  boot.cleanTmpDir = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

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

  users.defaultUserShell = pkgs.bash;

  environment.shells = with pkgs; [ fish ];
}
