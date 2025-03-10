{ config, pkgs, ... }:

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
    ../../mixins/power.nix
    ../../mixins/energy.nix
    ../../mixins/docker.nix
  ];

  networking.hostName = "thinkpad";

  console.keyMap = "fr";

  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    open = true;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:02:00:0";
    };
  };

  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # P52s fingerprint sensor is not supported
  # https://github.com/nmikhailov/Validity90/issues/34
  # services.fprintd.enable = true;
  # environment.systemPackages = with pkgs; [
  #   fprintd
  # ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp3s0";
  };
}
