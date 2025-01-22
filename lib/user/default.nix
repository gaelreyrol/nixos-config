{ inputs, ... }:

let
  inherit (inputs) self nixpkgs sops-nix nur home-manager udev-nix _1password-shell-plugins;
in
rec {
  mkHomeManagerEnvironement = { system, host, user, iso ? false, ... }: home-manager.lib.homeManagerConfiguration {
    modules = [ ];
    pkgs = import nixpkgs { inherit system; };
  };
  mkHomeManagerEnvironements = environments: builtins.listToAttrs (
    builtins.map
      (environment: {
        name = environment.user;
        value = mkHomeManagerEnvironement environment;
      })
      environments
  );
}
