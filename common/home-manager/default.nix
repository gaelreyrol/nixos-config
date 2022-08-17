{ ... }:

{
  imports = [
    ./firefox.nix
    ./gnome.nix
    ./fish.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = false;
  };
}