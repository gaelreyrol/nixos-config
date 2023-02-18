{ unstable, ... }:

final: prev: {
  nixUnstable = unstable.legacyPackages.${prev.system}.nix;
}
