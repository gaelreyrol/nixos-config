{ inputs, nixConf, ... }:

let
  inherit (inputs) self;
in
{
  mkNixOsSystem = { system, host, user }: inputs.nixpkgs.lib.nixosSystem rec {
    inherit system;

    specialArgs = {
      inherit self inputs;
    };

    modules = [
      (nixConf nixpkgs.legacyPackages.${system})
      ./hosts/${host}/configuration.nix
      ./users/${user}/configuration.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.nur.nixosModules.nur
      ./common/activation/system-report-changes.nix
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.lab = builtins.import ./users/${user}/home.nix;
      }
    ];
  };
}
