{ options, config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gaelreyrol.system.network;
in
{
  options.gaelreyrol.system.network = with types; {
    enable = mkEnableOption "Whether or not to manage network.";
    hosts = mkOption {
      type = attrs;
      default = { };
      description = "An attribute set to merge with <option>networking.hosts</option>";
    };
  };

  config = mkIf cfg.enable {
    gaelreyrol.user.extraGroups = [ "networkmanager" ];

    networking = {
      hosts = {
        "127.0.0.1" = [ "local.test" ] ++ (cfg.hosts."127.0.0.1" or [ ]);
      } // cfg.hosts;
    };

    networking.networkmanager.enable = true;
    networking.networkmanager.insertNameservers = [
      # dns0.eu
      "193.110.81.0"
      "185.253.5.0"
    ];
  };
}
