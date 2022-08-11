HOSTNAME = $(shell hostname)

nixos-switch:
	nixos-rebuild switch --flake .#${HOSTNAME} --impure

nixos-upgrade:
	nixos-rebuild switch --upgrade --flake .#${HOSTNAME} --impure

nix-flake-check:
	nix flake check

nix-profile-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system

nix-garbage-collect:
	nix-collect-garbage -d
