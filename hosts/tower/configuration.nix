{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../mixins/firmware.nix
    ../../mixins/fonts.nix
    ../../mixins/desktop.nix
    ../../mixins/audio.nix
    ../../mixins/bluetooth.nix
    ../../mixins/printing.nix
    ../../mixins/avahi.nix
    ../../mixins/energy.nix
    ../../mixins/docker.nix
  ];

  networking = {
    hostName = "tower";
    firewall = {
      # expo.dev
      interfaces.eno1.allowedTCPPorts = [ 8081 ];
      # Allow Docker containers to reach PHPStorm debugging sessions
      extraCommands = "iptables -I nixos-fw -p tcp -m tcp -m multiport --dports 9000:9003 -j ACCEPT";
    };
  };

  console.keyMap = "us";

  environment.systemPackages = with pkgs; [
    myPkgs.gnome-monitors-switch
    # myPkgs.mqttx
    klavaro
  ];

  # services.udev.packages = with pkgs; [ myPkgs.ledger-live-desktop ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    open = true;
    prime = {
      offload.enable = false;
      sync.enable = false;
      nvidiaBusId = "PCI:01:00:0";
    };
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "gael" ];

  programs.ccache.enable = true;
  programs.ccache.packageNames = [ ];
  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
}
