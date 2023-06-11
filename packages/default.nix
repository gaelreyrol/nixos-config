{ self, super }:

{
  gh-diff-pr = super.callPackage ./gh-diff-pr { };
  gnome-monitors-switch = super.callPackage ./gnome-monitors-switch { };
  ledger-live-desktop = super.callPackage ./ledger-live-desktop { };
  mqttx = super.callPackage ./mqttx { };
  shell-utils = super.callPackage ./shell-utils { };
  fishPlugins = super.fishPlugins.overrideScope' (fself: fsuper: {
    tmux = super.callPackage ./fish/plugins/tmux.nix { };
    jump = super.callPackage ./fish/plugins/jump.nix { };
  });
}
