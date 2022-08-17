{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.home-manager.ssh;
in {
  options.custom.home-manager.ssh = {
    enable = mkEnableOption "Enable SSH";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        # "github.com" = {
        #   extraOptions = {
        #     https://1password.community/discussion/121912/keyring-isnt-suid-on-nixos
        #     IdentityAgent = "~/.1password/agent.sock";
        #   };
        # };
        # Enable if recisio is enabled
        "dev.gael.office" = {
          user = "gael";
          identityFile = "~/.ssh/id_ed25519";
          forwardAgent = true;
        };
      };
    };
  };
}
