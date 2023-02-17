{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p53
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."system" =
    {
      device = "/dev/disk/by-uuid/40de7136-9a09-47cd-94e5-75901ad435f6";
      preLVM = true;
      allowDiscards = true;
    };

  boot.initrd.luks.devices."home".device = "/dev/disk/by-uuid/9b5b5ca3-c0d9-4874-87f0-ebda7b0a5ed0";

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/1f6936f9-91ed-4078-bd9c-584e968b58ec";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/171C-1D8F";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/8249e689-77a7-4509-a3c1-33a49f69d03e";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/39b840f0-273a-48ec-be06-344a55eeab7b"; }];

  nixpkgs.hostPlatform = "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
