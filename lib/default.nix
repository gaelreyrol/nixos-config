{ inputs, nixConf, ... }:

let
  inherit (inputs) self nixpkgs nur home-manager;
in
{
  mkNixosSystem = { system, host, user, ... }: nixpkgs.lib.nixosSystem rec {
    inherit system;

    specialArgs = {
      inherit self inputs;
    };

    modules = [
      (nixConf nixpkgs.legacyPackages.${system})
      ../hosts/${host}/configuration.nix
      ../users/${user}/configuration.nix
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      ../common/activation/system-report-changes.nix
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = builtins.import ../users/${user}/home.nix;
      }
    ];
  };
}
