{ self, super }:

{
  myPkgs = import ../../packages { inherit self super; };
  fishPlugins = super.fishPlugins.overrideScope' (fself: fsuper: {
    tmux = super.callPackage ../../packages/fish/plugins/tmux.nix { };
    jump = super.callPackage ../../packages/fish/plugins/jump.nix { };
  });
}
