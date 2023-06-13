{ self, super }:

{
  gh-diff-pr = super.callPackage ./gh-diff-pr { };
  gnome-monitors-switch = super.callPackage ./gnome-monitors-switch { };
  ledger-live-desktop = super.callPackage ./ledger-live-desktop { };
  mqttx = super.callPackage ./mqttx { };
  nixd = super.callPackage ./nixd { nixPackage = super.unstable.nixUnstable; };
  shell-utils = super.callPackage ./shell-utils { };
}
