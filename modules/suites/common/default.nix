{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.suites.common;
in
{
  options.gaelreyrol.suites.common = with types; {
    enable = mkEnableOption "Whether or not to enable common common configuration.";
  };

  config = mkIf cfg.enable {
    gaelreyrol = {
      nix.enable = true;
    };


    environment.systemPackages = with pkgs; [
      openssl
      gnumake
      pciutils
      vim
      wget
      curl
      git
      jq
      ripgrep
      fzf
      dogdns
      exa
      bat
      delta
      duf
      broot
      fd
      tldr
      procs
      nixpkgs-fmt
      nixdoc
      nvd
    ];
  };
}
