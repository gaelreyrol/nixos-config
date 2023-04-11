{ config, pkgs, ... }:

# ToDo: Add icon from nix-artwork
let
  nix = pkgs.makeDesktopItem {
    name = "nix";
    desktopName = "Nix";
    exec = "${pkgs.vscodium}/bin/codium /home/gael/.config/nix";
    terminal = false;
  };
in
{
  home.packages = with pkgs; [ nix ];
}
