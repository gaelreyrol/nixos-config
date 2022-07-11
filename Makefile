HOSTNAME = $(shell hostname)


fmt:
	nixpkgs-fmt **/*.nix

nixos-switch:
	nixos-rebuild switch --flake .#${HOSTNAME}

nixos-upgrade:
	nixos-rebuild switch --upgrade --flake .#${HOSTNAME}

nixos-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system
