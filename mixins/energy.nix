{ pkgs, ... }:

let
  port = 8080;
in
{
  boot.kernelModules = [ "intel_rapl_common" ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ port ];
  };

  systemd.services.scaphandre-prometheus = {
    description = "Scaphandre electrical power consumption metrology agent service";

    after = [ "network-pre.target" ];
    wants = [ "network-pre.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.unstable.scaphandre}/bin/scaphandre prometheus --port=${builtins.toString port}";
    };
  };
}
