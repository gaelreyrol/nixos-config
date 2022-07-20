HOSTNAME = $(shell hostname)

nixos-switch:
	sudo nixos-rebuild switch --flake .#${HOSTNAME}

nixos-upgrade:
	sudo nixos-rebuild switch --upgrade --flake .#${HOSTNAME}

nix-flake-check:
	nix flake check

nix-profile-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system

nix-garbage-collect:
	sudo nix-collect-garbage -d
