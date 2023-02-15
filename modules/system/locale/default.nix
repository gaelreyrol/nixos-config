{ options, config, pkgs, lib, ... }:

with lib;

let
  cfg = config.myNixOSModules.system.locale;
in
{
  options.myNixOSModules.system.locale = with types; {
    enable = mkEnableOption "Whether or not to manage locale settings.";
    keyMap = mkOption {
      type = (enum [ "us" "fr" ]);
      default = "us";
      description = "Which keyboard layout do you want to use by default.";
    };
  };

  config = mkIf cfg.enable {
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = mkDefault cfg.keyMap;
  };
}
