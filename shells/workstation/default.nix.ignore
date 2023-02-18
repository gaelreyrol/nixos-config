{ pkgs, home-manager }:

{
  packages = builtins.attrValues {
    inherit (pkgs) nixos-generators vulnix sbomnix;
    inherit (home-manager) home-manager;
  };
}
