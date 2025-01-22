{ config, pkgs, inputs, ... }:

let
  inherit (inputs) _1password-shell-plugins;
in
{
  users.users.gael = {
    isNormalUser = true;
    description = "Gaël Reyrol";
    extraGroups = [ "wheel" "networkmanager" "onepassword" "onepassword-cli" "docker" "input" ];
    shell = pkgs.fish;
  };

  programs = {
    fish.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "gael" ];
    };
    _1password-shell-plugins = {
      enable = true;
      plugins = with pkgs; [ gh cachix ];
    };
  };

  sops.age.keyFile = "/home/gael/.config/sops/age/keys.txt";

  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "gael";

  # security.pam.yubico = {
  #   enable = true;
  #   debug = true;
  #   control = "required";
  #   mode = "challenge-response";
  # };

  services.pcscd.enable = true;

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
}
