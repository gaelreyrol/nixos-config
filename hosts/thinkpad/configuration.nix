{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/firmware.nix
    ../common/fonts.nix
    ../common/desktop.nix
    ../common/audio.nix
    ../common/bluetooth.nix
    ../common/printing.nix
    ../common/avahi.nix
    ../common/power.nix
  ];

  networking.hostName = "thinkpad";

  console.keyMap = "fr";

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:02:00:0";
  };

  services.xserver = {
    layout = "fr";
    xkbVariant = "azerty";
  };

  # P52s fingerprint sensor is not supported
  # https://github.com/nmikhailov/Validity90/issues/34
  # services.fprintd.enable = true;
  # environment.systemPackages = with pkgs; [
  #   fprintd
  # ];

  environment.systemPackages = with pkgs; [
    myPkgs.mqttx
    myPkgs.ledger-live-desktop
  ];
}
