{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, cmake
, pkg-config
, lit
, nixUnstable
, boost182
, gtest
, llvmPackages_16
, libbacktrace
, nix-update-script

  # The default Nix package to use as build dependency
, nixPackage ? nixUnstable
}:

let
  filterMesonBuild = builtins.filterSource
    (path: type: type != "directory" || baseNameOf path != "build");
in
stdenv.mkDerivation rec {
  pname = "nixd";
  version = "1.0.0";

  src = filterMesonBuild (fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    rev = version;
    hash = "sha256-kTDPbsQi9gzFAFkiAPF+V3yI1WBmILEnnsqdgHMqXJA=";
  });

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config

    # Testing only
    lit

    (lib.getDev nixPackage)
    (lib.getDev boost182)
    (lib.getDev gtest)
    (lib.getDev llvmPackages_16.llvm)
    llvmPackages_16.clang
  ];

  buildInputs = [
    libbacktrace
    nixPackage
    gtest
    (lib.getDev boost182)
    (lib.getLib llvmPackages_16.llvm)
  ];

  CXXFLAGS = "-include ${lib.getDev nixPackage}/include/nix/config.h";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nix language server";
    homepage = "https://github.com/nix-community/nixd";
    changelog = "https://github.com/nix-community/nixd/releases/tag/${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
# https://github.com/nix-community/nixd/issues/109
# Until nixd is availaible in nixpkgs
