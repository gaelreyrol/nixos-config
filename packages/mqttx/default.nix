{ lib, fetchurl, appimageTools, imagemagick, pkgs }:

let
  pname = "mqttx";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/emqx/MQTTX/releases/download/v${version}/MQTTX-${version}.AppImage";
    hash = "sha256-adhQXw1+2ioQESdRt/mC5yVp1jFrRR315TED/gCUI1s=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/1024x1024/apps/${pname}.png
    ${imagemagick}/bin/convert ${appimageContents}/mqttx.png -resize 512x512 ${pname}_512.png
    install -m 444 -D ${pname}_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Powerful cross-platform MQTT 5.0 Desktop, CLI, and WebSocket client tools";
    homepage = "https://mqttx.app/";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
