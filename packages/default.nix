{ final, prev }:

{
  gh-diff-pr = prev.callPackage ./gh-diff-pr { };
  gnome-monitors-switch = prev.callPackage ./gnome-monitors-switch { };
  ledger-live-desktop = prev.callPackage ./ledger-live-desktop { };
  mqttx = prev.callPackage ./mqttx { };
  nixd = prev.callPackage ./nixd { nixPackage = prev.unstable.nixUnstable; };
  shell-utils = prev.callPackage ./shell-utils { };
}
