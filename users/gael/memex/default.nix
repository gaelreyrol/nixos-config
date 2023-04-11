{ config, pkgs, ... }:

let
  memex = pkgs.makeDesktopItem {
    name = "memex";
    desktopName = "Memex";
    exec = "${pkgs.vscodium}/bin/codium /home/gael/Development/Perso/memex.code-workspace";
    terminal = false;
  };
in
{
  home.packages = with pkgs; [ memex ];
}
