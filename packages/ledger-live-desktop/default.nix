{ lib, fetchurl, appimageTools, imagemagick, pkgs }:

# TODO: Package from source: https://github.com/LedgerHQ/ledger-live
let
  pname = "ledger-live-desktop";
  version = "2.57.0";

  src = fetchurl {
    url = "https://download.live.ledger.com/ledger-live-desktop-${version}-linux-x86_64.AppImage";
    hash = "sha256-fXvCj9eBEp/kGPSiNUdir19eU0x461KzXgl5YgeapHI=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  udev-rules = fetchTarball {
    url = "https://github.com/LedgerHQ/udev-rules/archive/9bf0cbbef09437024729ea34db541535a8cb3807.zip";
    sha256 = "0swx9fd2j8v0878r02gmr3wmkcniva1bkyiqlbyi75x5zrpbcppd";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    for i in 128 256 512 1024; do
      size="$i"x"$i"
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/$size/apps/${pname}.png $out/share/icons/hicolor/$size/apps/${pname}.png
    done
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${udev-rules}/20-hw1.rules $out/lib/udev/rules.d/20-hw1.rules
  '';

  meta = with lib; {
    description = "Ledger Live lets you manage your crypto assets with the security of your Ledger device.";
    homepage = "https://www.ledger.com/ledger-live";
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}
