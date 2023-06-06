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
  ];

  networking.hostName = "tower";

  console.keyMap = "us";

  environment.systemPackages = with pkgs; [
    myPkgs.gnome-monitors-switch
    myPkgs.mqttx
    myPkgs.ledger-live-desktop
    klavaro
  ];

  services.udev.packages = with pkgs; [ myPkgs.ledger-live-desktop ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  hardware.nvidia.prime = {
    offload.enable = false;
    sync.enable = false;
    nvidiaBusId = "PCI:01:00:0";
  };

  mention.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "gael" ];
}
