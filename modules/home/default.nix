{ options, config, pkgs, lib, home-manager, ... }:

with lib;

let
  cfg = config.gaelreyrol.home;
in
{
  options.gaelreyrol.home = with types; {
    file = mkOption {
      type = attrs;
      default = { };
      description = "A set of files to be managed by home-manager's <option>home.file</option>.";
    };
    configFile = mkOption {
      type = attrs;
      default = { };
      description = "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Options to pass directly to home-manager.";
    };
  };

  config = {
    gaelreyrol = {
      home.report-changes.enable = true;

      home.extraOptions = {
        home.stateVersion = config.system.stateVersion;
        home.file = mkAliasDefinitions options.gaelreyrol.home.file;
        xdg.enable = true;
        xdg.configFile = mkAliasDefinitions options.gaelreyrol.home.configFile;
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.${config.gaelreyrol.user.name} =
        mkAliasDefinitions options.gaelreyrol.home.extraOptions;
    };
  };
}
