{ lib, modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    (modulesPath + "/installer/cd-dvd/channel.nix")
  ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = pkgs.unstable.linuxKernel.packages.linux_6_8;

    # Needed for https://github.com/NixOS/nixpkgs/issues/58959
    supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
}
