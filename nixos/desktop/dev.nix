{ config, pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      vscodium
      jetbrains.phpstorm
      insomnia

      php81
      php81Packages.composer
      symfony-cli
      nodejs
      nodePackages.npm
      nodePackages.yarn
      go

      postgresql_14

      terraform
      ansible
      ansible-lint
      shellcheck
      dhall
      dhall-json

      exercism
    ];
  };
}
