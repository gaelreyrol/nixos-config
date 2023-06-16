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

# ToDo: Remove when merge in nixos-unstable https://nixpk.gs/pr-tracker.html?pr=236675
let
  filterMesonBuild = builtins.filterSource
    (path: type: type != "directory" || baseNameOf path != "build");
in
stdenv.mkDerivation rec {
  pname = "nixd";
  version = "2023-06-15";

  src = filterMesonBuild (fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    rev = "d38d09ab343f17653fabb68cfc3b65a67e5a7a3e";
    hash = "sha256-SWoZJRpOdeOmiktgV5PleWL9W+314MBg9ExPx+z/koE=";
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
