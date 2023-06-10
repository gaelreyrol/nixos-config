{ self, super }:

{
  fishPlugins = super.fishPlugins.overrideScope' (fself: fsuper: {
    tmux = super.callPackage ../../packages/fish/plugins/tmux.nix { };
  });
}
