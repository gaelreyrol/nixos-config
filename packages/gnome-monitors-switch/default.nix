{ stdenv, writeShellScriptBin, symlinkJoin }:

let
  monitorsFiles = stdenv.mkDerivation {
    name = "gnome-monitors-files";
    src = ./.;

    installPhase = ''
      cp -r ./monitors $out
    '';
  };
  shellScript = writeShellScriptBin "gnome-monitors-switch" ''
    #! /usr/bin/env bash

    set -eu

    MONITORS_PATH="${monitorsFiles}"

    USER=$(whoami)
    USER_MONITORS_PATH="/home/$USER/.config/monitors.xml"

    function switch {
      clear
      printf "\e[1mSELECTING VIDEO OUTPUT\e[0m\n  1 -> WORKSTATION\n  2 -> TV\n  3 -> CANCEL\n\n"
      read -p "Option: " a
        if [ "$a" = "1" ]; then
          clear
          printf "Switching to WORKSTATION..."
            rm $USER_MONITORS_PATH
            ln -s $MONITORS_PATH/workstation.xml $USER_MONITORS_PATH && pkill -SIGQUIT gnome-shell
        elif [ "$a" = "2" ]; then
          clear
          printf "Switching to TV..."
            rm $USER_MONITORS_PATH
            ln -s $MONITORS_PATH/monitors/tv.xml $USER_MONITORS_PATH && pkill -SIGQUIT gnome-shell
        elif [ "$a" = "3" ]; then
          clear
          printf "Quitting script..." && sleep 1s
        fi
      exit 0
    }

    switch
  '';
in
symlinkJoin {
  name = "gnome-monitors-switch";

  paths = [
    monitorsFiles
    shellScript
  ];
}