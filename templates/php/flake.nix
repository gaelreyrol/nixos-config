{
  description = "A basic php flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "unstable";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs.follows = "unstable";

    php-shell.url = "github:loophp/nix-shell";
  };

  outputs = { self, nixpkgs, treefmt-nix, pre-commit-hooks, php-shell, ... }:
    let
      forSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
        ]
          (system:
            function {
              inherit system;
              pkgs = import nixpkgs {
                inherit system;
              };
            }
          );

      php = system: (php-shell.api.makePhp system {
        php = "php81";
        withExtensions = [ ];
        extraConfig = ''
          memory_limit=-1
        '';
      });

      phpTools = [
        php.packages.composer
        php.packages.php-cs-fixer
      ];

    in
    {
      formatter = forSystems ({ pkgs, system }: treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs.nixpkgs-fmt.enable = true;
      });

      checks = forSystems ({ pkgs, system }: {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            statix.enable = true;
            markdownlint.enable = true;
            editorconfig-checker.enable = true;
            actionlint.enable = true;
            php-cs-fixer.enable = true;
          };
        };
      });

      devShells = forSystems ({ pkgs, system }: {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.treefmt
            pkgs.editorconfig-checker
            pkgs.actionlint
            (php system)
          ] ++ phpTools;
          inherit (self.checks."${system}".pre-commit-check) shellHook;
        };
      });
    };
}
