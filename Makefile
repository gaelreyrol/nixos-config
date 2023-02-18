HOSTNAME = $(shell hostname)
USER = $(shell whoami)

system-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system

home-manager-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/per-user/${USER}/home-manager

nixos-switch:
	nixos-rebuild switch --flake .#${HOSTNAME}

nixos-upgrade:
	nixos-rebuild switch --upgrade --flake .#${HOSTNAME}

nixos-build:
	nixos-rebuild build --flake .#${HOSTNAME}

nix-garbage-collect:
	nix-collect-garbage -d

pi0-deploy:
	nixos-rebuild switch -j auto --flake .#pi0 --build-host localhost --target-host lab@192.168.1.14 --use-remote-sudo -v
