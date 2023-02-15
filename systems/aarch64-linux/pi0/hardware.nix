{ config, lib, pkgs, modulesPath, inputs, ... }:

let
  inherit (inputs) nixos-hardware;
in
{
  imports =
    with nixos-hardware.nixosModules; [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;

  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.initrd.availableKernelModules = [ "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "console=ttyS1,115200n8"
  ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  hardware.enableRedistributableFirmware = true;
}
