{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkgconfig
, openssl
, powercap
}:

rustPlatform.buildRustPackage rec {
  pname = "scaphandre";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "hubblo-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cXwgPYTgom4KrL/PH53Fk6ChtALuMYyJ/oTrUKHCrzE=";
  };

  cargoSha256 = "sha256-Vdkq9ShbHWepvIgHPjhKY+LmhjS+Pl84QelgEpen7Qs=";

  nativeBuildInputs = [ pkgconfig powercap ];
  buildInputs = [ openssl ];

  checkPhase = ''
    runHook preCheckPhase

    # https://github.com/hubblo-org/scaphandre/blob/v0.5.0/src/sensors/powercap_rapl.rs#L29
    export SCAPHANDRE_POWERCAP_PATH="/tmp/scaphandre"

    mkdir -p "$SCAPHANDRE_POWERCAP_PATH"

    runHook postCheckPhase
  '';

  meta = with lib; {
    description = "Electrical power consumption metrology agent";
    homepage = "https://github.com/hubblo-org/scaphandre";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
