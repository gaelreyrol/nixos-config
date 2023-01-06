{ config, lib, pkgs, ... }:

with lib;

let cfg = config.system.yubikey;
in {
  options.system.yubikey = {
    enable = mkEnableOption "Enable Yubikey";
  };

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [ yubikey-personalization ];

    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-manager
      yubikey-manager-qt
    ];

    # security.pam.yubico = {
    #   enable = true;
    #   debug = true;
    #   control = "required";
    #   mode = "challenge-response";
    # };

    # systemd.services."xlock" = {
    #   description = "Lock all sessions with loginctl";
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.systemd}/bin/loginctl lock-sessions";
    #   };
    # };

    ## Start xlock.service on unplugged Yubikey 
    # services.udev.extraRules = ''
    #   ACTION=="remove", SUBSYSTEM=="input", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0010|0110|0111|0114|0116|0401|0403|0405|0407|0410", ENV{ID_SECURITY_TOKEN}="1", RUN+="${pkgs.systemd}/bin/systemctl start xlock.service"
    # '';
  };
}
