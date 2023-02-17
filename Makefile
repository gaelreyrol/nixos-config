HOSTNAME = $(shell hostname)
USER = $(shell whoami)

system-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system

home-manager-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/per-user/${USER}/home-manager

nixos-switch:
	nixos-rebuild switch --flake .#${HOSTNAME}

nixos-build:
	nixos-rebuild build --flake .#${HOSTNAME}

nix-garbage-collect:
	nix-collect-garbage -d
