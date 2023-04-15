{ lib, fetchurl, appimageTools, imagemagick, pkgs }:

let
  pname = "ledger-live-desktop";
  version = "2.55.0";

  src = fetchurl {
    url = "https://download.live.ledger.com/ledger-live-desktop-${version}-linux-x86_64.AppImage";
    hash = "sha256-N0BhbqZvZs3IP+jMxr85KlHs6I/fxWgoK884EKT9C9Y=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ mesa ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Ledger Live lets you manage your crypto assets with the security of your Ledger device.";
    homepage = "https://www.ledger.com/ledger-live";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}
