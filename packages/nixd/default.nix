{ stdenv
, meson
, ninja
, cmake
, pkg-config
, lit
, unstable
, boost182
, gtest
, llvmPackages_16
, libbacktrace
, lib
, fetchFromGitHub
}:

let
  filterMesonBuild = builtins.filterSource
    (path: type: type != "directory" || baseNameOf path != "build");

  llvmPackages = llvmPackages_16;

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

    unstable.nixUnstable.dev
    boost182.dev
    gtest.dev
    llvmPackages.llvm.dev
    llvmPackages.clang
  ];

  buildInputs = [
    libbacktrace
    unstable.nixUnstable
    gtest
    boost182.dev

    llvmPackages.llvm.lib
  ];

  CXXFLAGS = "-include ${unstable.nixUnstable.dev}/include/nix/config.h";

  meta = {
    description = "Nix language server";
    homepage = "https://github.com/nix-community/nixd";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
# https://github.com/nix-community/nixd/issues/109
# Until nixd is availaible in nixpkgs
