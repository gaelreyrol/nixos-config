HOSTNAME = $(shell hostname)
USER = $(shell whoami)

home-manager-switch:
	home-manager switch --flake .#${USER}@${HOSTNAME}

home-manager-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/per-user/${USER}/home-manager

nixos-switch:
	nixos-rebuild switch --flake .#${HOSTNAME} --impure

nixos-upgrade:
	nixos-rebuild switch --upgrade --flake .#${HOSTNAME} --impure

nixos-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system

nix-flake-check:
	nix flake check

nix-garbage-collect:
	nix-collect-garbage -d
