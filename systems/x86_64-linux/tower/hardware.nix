{ config, lib, pkgs, modulesPath, inputs, ... }:

let
  inherit (inputs) nixos-hardware;
in
{
  imports =
    with nixos-hardware.nixosModules; [
      (modulesPath + "/installer/scan/not-detected.nix")
      common-cpu-intel
      common-gpu-nvidia
      common-pc
      common-pc-ssd
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;


  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/5f9478fd-4c06-4548-a111-02a2cb85beed";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/E786-3716";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/0753de4a-c9de-4564-b166-f3973edc21fb";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

