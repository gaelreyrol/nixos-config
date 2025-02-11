{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
      };
    };

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      systemd.network.wait-online.enable = lib.mkForce false;
    };

    kernelPackages = pkgs.linuxKernel.packages.linux_6_6;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    # Type-C controller is not supported https://askubuntu.com/a/1289997
    # extraModprobeConfig = ''
    #   blacklist i2c_nvidia_gpu
    # '';

    # RODE Microphones RØDE NT-USB Mini quirk alias https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/sound/usb/quirks.c
    # kernelParams = [ "snd-usb-audio.quirk_alias=19f70015:047f02f7" ];

    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5f9478fd-4c06-4548-a111-02a2cb85beed";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/E786-3716";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/0753de4a-c9de-4564-b166-f3973edc21fb";
      fsType = "ext4";
    };
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
