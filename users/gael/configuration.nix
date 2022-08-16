{ config, pkgs, ... }:

{
  users.users.gael = {
    isNormalUser = true;
    description = "Gaël Reyrol";
    extraGroups = [ "wheel" "networkmanager" "onepassword" ];
    shell = pkgs.fish;
  };

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "gael" ];
  };

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
}

