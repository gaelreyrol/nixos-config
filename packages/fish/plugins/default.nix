{ pkgs, ... }: {
  tmux = pkgs.callPackage ./tmux.nix { inherit pkgs; };
}
