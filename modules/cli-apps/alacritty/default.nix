{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.cli-apps.alacritty;
in
{
  options.gaelreyrol.cli-apps.alacritty = with types; {
    enable = mkEnableOption "Whether or not to enable Alacritty.";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "JetBrains Mono";
          size = 12.0;
        };

        colors = {
          primary = {
            background = "#fdf6e3";
            foreground = "#657b83";
          };
          cursor = {
            text = "#fdf6e3";
            curser = "#657b83";
          };
          normal = {
            black = "#073642";
            red = "#dc322f";
            green = "#859900";
            yellow = "#b58900";
            blue = "#268bd2";
            magenta = "#d33682";
            cyan = "#2aa198";
            white = "#eee8d5";
          };
          bright = {
            black = "#002b36";
            red = "#cb4b16";
            green = "#586e75";
            yellow = "#657b83";
            blue = "#839496";
            magenta = "#6c71c4";
            cyan = "#93a1a1";
            white = "#fdf6e3";
          };
        };
      };
    };
  };
}
