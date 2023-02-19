#! /usr/bin/env bash

set -eu

function monitors-switch {
  clear
  printf "\e[1mSELECTING VIDEO OUTPUT\e[0m\n  1 -> WORKSTATION\n  2 -> TV\n  3 -> CANCEL\n\n"
  read -p "Option: " a
    if [ "$a" = "1" ]; then
      clear
      printf "Switching to WORKSTATION..."
        ln -s ~/.config/nix/assets/monitors/workstation.xml ~/.config/monitors.xml && killall -SIGQUIT gnome-shell
    elif [ "$a" = "2" ]; then
      clear
      printf "Switching to TV..."
        ln -s ~/.config/nix/assets/monitors/tv.xml ~/.config/monitors.xml && killall -SIGQUIT gnome-shell
    elif [ "$a" = "3" ]; then
      clear
      printf "Quitting script..." && sleep 1s
    fi
  exit 0
}

monitors-switch