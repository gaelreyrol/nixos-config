{ options, config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gaelreyrol.system.fonts;
in
{
  options.gaelreyrol.system.fonts = with types; {
    enable = mkEnableOption "Whether or not to manage fonts.";
    fonts = mkOption {
      type = (listOf package);
      default = [ ];
      description = "Custom font packages to install.";
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    fonts.fontconfig.enable = true;

    environment.systemPackages = with pkgs; [ font-manager ];

    fonts.fonts = with pkgs;
      [
        jetbrains-mono
      ] ++ cfg.fonts;
  };
}
