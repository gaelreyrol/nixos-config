{ pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  config = {
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15;

    hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

    environment.systemPackages = with pkgs; [
      pciutils
    ];
  };
}
