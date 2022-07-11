{
  description = "system configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/release-22.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager }:
    let
      lib = nixpkgs.lib;
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
      };
    in
    {
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            modules = [
                (nixConf nixpkgs.legacyPackages.${system})
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.gael = import ./home.nix;
                }
            ];
        };
      };
    };
}