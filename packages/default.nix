{ pkgs, ... }:

{
  fishPlugins = import ./fish/plugins { inherit pkgs; };
  gnome-monitors-switch = pkgs.callPackage ./gnome-monitors-switch { };
  ledger-live-desktop = pkgs.callPackage ./ledger-live-desktop { inherit pkgs; };
  mqttx = pkgs.callPackage ./mqttx { inherit pkgs; };
  shell-utils = pkgs.callPackage ./shell-utils { };
}
