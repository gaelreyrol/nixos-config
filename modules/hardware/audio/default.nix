{ options, config, pkgs, lib, ... }:

with lib;

let cfg = config.gaelreyrol.hardware.audio;
in
{
  options.gaelreyrol.hardware.audio = with types; {
    enable = mkEnableOption "Whether or not to manage audio.";
  };

  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = mkForce false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
