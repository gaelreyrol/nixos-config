{ config, pkgs, ... }:

{
  services.udev.extraRules = pkgs.udev-nix.toUdevFile "power-supply.rules" {
    # Test with: sudo udevadm test (udevadm info /sys/class/power_supply/AC --query=path)
    # Documentation: https://docs.kernel.org/power/power_supply_class.html
    rules = with pkgs.udev-nix; {
      "Power Saver mode" = {
        Subsystem = operators.match "power_supply";
        Env = {
          "POWER_SUPPLY_ONLINE" = operators.match "0";
        };
        Run = operators.add "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver";
      };
      "Performance mode" = {
        Subsystem = operators.match "power_supply";
        Env = {
          "POWER_SUPPLY_ONLINE" = operators.match "1";
        };
        Run = operators.add "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
      };
    };
  };
}
