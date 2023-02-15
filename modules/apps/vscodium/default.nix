{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.gaelreyrol.apps.vscode;
in
{
  options.gaelreyrol.apps.vscode = with types; {
    enable = mkEnableOption "Whether or not to enable VSCodium.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rnix-lsp
      nixpkgs-fmt
      dhall-lsp-server
      shellcheck
      checkmake
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        editorconfig.editorconfig
        jnoortheen.nix-ide
        octref.vetur
        foam.foam-vscode
        yzhang.markdown-all-in-one
        hashicorp.terraform
        redhat.vscode-yaml
        timonwong.shellcheck
        gruntfuggly.todo-tree
        dhall.vscode-dhall-lsp-server
        bungcip.better-toml
        dhall.dhall-lang
      ];
      userSettings = {
        "redhat.telemetry.enabled" = false;
        "workbench.colorTheme" = "Solarized Light";
        "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontSize" = 16;
        "nix.enableLanguageServer" = true;
        # TODO: Use nixpkgs absolute paths
        "nix.serverPath" = "rnix-lsp";
        "nix.formatterPath" = "nixpkgs-fmt";
        "vscode-dhall-lsp-server.executable" = "dhall-lsp-server";
        "shellcheck.executablePath" = "shellcheck";
      };
    };

    gaelreyrol.home = {
      extraOptions = {
        home.shellAliases = {
          code = "${pkgs.vscodium}/bin/codium";
        };
      };
    };
  };
}
