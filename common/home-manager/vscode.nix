{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.home-manager.vscode;
in {
  options.custom.home-manager.vscode = {
    enable = mkEnableOption "Enable VSCodium";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      # https://github.com/nix-community/home-manager/issues/2798
      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        editorconfig.editorconfig
        # vscode-icons-team.vscode-icons
        jnoortheen.nix-ide
        octref.vetur
        foam.foam-vscode
        yzhang.markdown-all-in-one
        # kortina.vscode-markdown-notes
        # mushan.vscode-paste-image
        hashicorp.terraform
        redhat.vscode-yaml
        # redhat.ansible
        timonwong.shellcheck
        gruntfuggly.todo-tree
        dhall.vscode-dhall-lsp-server
      ];
      userSettings = {
        # ToDo: Parametrize
        "workbench.colorTheme" = "${globalCfg.colorTheme}";
        "editor.fontFamily" = "'${globalCfg.fontFamily}', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontSize" = 16;
        "nix.enableLanguageServer" = true;
      };
    };
  };
}
