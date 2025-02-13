{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p53
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        "system" = {
          device = "/dev/disk/by-uuid/40de7136-9a09-47cd-94e5-75901ad435f6";
          preLVM = true;
          allowDiscards = true;
        };
        "home" = { device = "/dev/disk/by-uuid/9b5b5ca3-c0d9-4874-87f0-ebda7b0a5ed0"; };
      };
    };

    kernelPackages = pkgs.linuxKernel.packages.linux_6_6;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1f6936f9-91ed-4078-bd9c-584e968b58ec";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/171C-1D8F";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/8249e689-77a7-4509-a3c1-33a49f69d03e";
      fsType = "ext4";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/39b840f0-273a-48ec-be06-344a55eeab7b"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
