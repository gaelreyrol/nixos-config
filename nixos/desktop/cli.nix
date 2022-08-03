{ config, pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
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
      httpie
      nixpkgs-fmt
      rnix-lsp
      nixdoc
      _1password
      keybase
      kbfs
    ];
  };
}
