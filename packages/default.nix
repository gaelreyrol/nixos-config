{ pkgs, ... }:

{
  gnome-monitors-switch = pkgs.callPackage ./gnome-monitors-switch { };
  mqttx = pkgs.callPackage ./mqttx { inherit pkgs; };
  shell-utils = pkgs.callPackage ./shell-utils { };
  fishPlugins = {
    tmux = pkgs.callPackage ./fish/plugins/tmux.nix { inherit pkgs; };
  };
}
