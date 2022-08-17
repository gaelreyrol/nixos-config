{ config, lib, pkgs, modulesPath, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."system" =
    {
      device = "/dev/disk/by-uuid/4c5d78a4-6953-4bfa-8c7d-44c1b0acca33";
      preLVM = true;
      allowDiscards = true;
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/2BBB-3DBB";
      fsType = "vfat";
    };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/08826e9d-a542-4d92-bd9f-b9954b4b96a3";
      fsType = "ext4";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/019db7bb-85ea-4b1c-be50-fb085d776f83";
      fsType = "ext4";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f57c7654-12be-4b18-b2f6-ff56f2f0b937"; }];

  powerManagement.cpuFreqGovernor = "powersave";

  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:01:00:0";
  };
}
