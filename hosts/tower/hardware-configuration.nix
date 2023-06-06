{ inputs, config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_1;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Type-C controller is not supported https://askubuntu.com/a/1289997
  # boot.extraModprobeConfig = ''
  #   blacklist i2c_nvidia_gpu
  # '';

  # RODE Microphones RØDE NT-USB Mini quirk alias https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/sound/usb/quirks.c
  # boot.kernelParams = [ "snd-usb-audio.quirk_alias=19f70015:047f02f7" ];

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

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
