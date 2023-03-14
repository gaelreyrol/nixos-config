{ pkgs, ... }:

pkgs.appimageTools.wrapType2 {
  name = "mqttx";
  src = pkgs.fetchurl {
    url = "https://github.com/emqx/MQTTX/releases/download/v1.9.1/MQTTX-1.9.1.AppImage";
    sha256 = "sha256-adhQXw1+2ioQESdRt/mC5yVp1jFrRR315TED/gCUI1s=";
  };
  extraPkgs = pkgs: with pkgs; [ ];
}
