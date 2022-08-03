{ config, pkgs, lib, ... }:
let cfg = config.desktop.gnome;
in
{
  options.desktop.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  imports = [
    ./dconf.nix
  ];

  config = mkIf cfg.enable {
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    services.gnome.chrome-gnome-shell.enable = true;
    services.gnome.gnome-keyring.enable = true;

    services.dbus.packages = with pkgs; [ dconf ];
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon yubikey-personalization ];

    security.pam.services.gdm.enableGnomeKeyring = true;
    security.pam.services."gdm-password".enableGnomeKeyring = true;
    security.pam.services."gdm-launch-environment".enableGnomeKeyring = true;

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      xdg-utils
      gthumb
      gnome.gnome-tweaks
      gnome.dconf-editor
      gnome.gnome-themes-extra
      gnomeExtensions.user-themes
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.gsconnect
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.removable-drive-menu
      dconf2nix
    ];

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-maps
      gnome-weather
      epiphany # web browser
      geary # email reader
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
  };

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
