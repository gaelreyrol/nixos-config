{ final, prev }:

{
  myPkgs = import ../../packages { inherit final prev; };
  fishPlugins = prev.fishPlugins.overrideScope (ffinal: fprev: {
    tmux = prev.callPackage ../../packages/fish/plugins/tmux.nix { };
    jump = prev.callPackage ../../packages/fish/plugins/jump.nix { };
  });
}
