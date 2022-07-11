{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/release-22.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager }:
    let
      nixConf = pkgs: {
        nix = {
          package = pkgs.nixFlakes;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
          autoOptimiseStore = true;
          gc = {
            automatic = true;
            dates = "daily";
            persistent = true;
            options = "--delete-older-than 60d";
          };
        };
        nixpkgs.config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            (nixConf nixpkgs.legacyPackages.${system})
            ./hosts/thinkpad/hardware-configuration.nix
            ./hosts/thinkpad/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gael = import ./users/gael/home.nix;
            }
          ];
        };
      };
    };
}
