{ options, config, pkgs, lib, ... }:

with lib;

let
  cfg = config.gaelreyrol.user;
in
{
  options.gaelreyrol.user = with types; {
    name = mkOption {
      type = str;
      default = "gael";
      description = "The name to use for the user account.";
    };
    fullName = mkOption {
      type = str;
      default = "Gaël Reyrol";
      description = "The full name of the user.";
    };
    email = mkOption {
      type = str;
      default = "me@gaelreyrol.com";
      description = "The email of the user.";
    };
    initialPassword = mkOption {
      type = str;
      default = "password";
      description = "The initial password to use when the user is first created.";
    };
    extraGroups = mkOption {
      type = (listOf str);
      default = [ ];
      description = "Groups for the user to be assigned.";
    };
    extraOptions = mkOption {
      type = attrs;
      default = { };
      description = "Extra options passed to <option>users.users.<name></option>.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      vim
      jq
      bat
      exa
      dog
    ];

    gaelreyrol.home = {
      extraOptions = {
        home.shellAliases = {
          dig = "${pkgs.dog}/bin/dog";
          ls = "${pkgs.exa}/bin/exa";
          cat = "${pkgs.bat}/bin/bat";
        };

        home.sessionVariables = {
          EDITOR = "vim";
          BAT_THEME = "Solarized (light)";
        };

        programs = {
          vim.enable = true;
          jq.enable = true;
          ssh.enable = true;
        };
      };
    };

    users.defaultUserShell = pkgs.bash;

    users.users.${cfg.name} = {
      isNormalUser = true;

      inherit (cfg) name initialPassword;

      home = "/home/${cfg.name}";
      group = "users";

      shell = pkgs.fish;

      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
