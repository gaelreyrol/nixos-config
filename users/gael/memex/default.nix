{ config, pkgs, ... }:

let
  memex = pkgs.writeTextFile {
    name = "memex.desktop";
    destination = "/share/applications/memex.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Terminal=false
      Name=Memex
      Exec=${pkgs.vscodium}/bin/codium Development/Perso/memex.code-workspace
    '';
  };
in
{
  home.packages = with pkgs; [ memex ];
}
