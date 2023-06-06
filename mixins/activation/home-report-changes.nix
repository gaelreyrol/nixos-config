{ config, pkgs, lib, ... }:

{
  home.activation.report-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/per-user/gael/home-manager-*-link | tail -2) && echo 'OK' || echo 'NOK'
  '';
}
