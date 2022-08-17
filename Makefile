HOSTNAME = $(shell hostname)
USER = $(shell whoami)

home-manager-switch:
	home-manager switch --flake .#${USER}@${HOSTNAME}

home-manager-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/per-user/${USER}/home-manager
	ls -v -d /nix/var/nix/profiles/per-user/${USER}/home* | tail -n 2 | xargs nvd diff

nixos-switch:
	nixos-rebuild switch --flake .#${HOSTNAME} --impure

nixos-upgrade:
	nixos-rebuild switch --upgrade --flake .#${HOSTNAME} --impure

nixos-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system
		ls -v /nix/var/nix/profiles | tail -n 2 | awk '{print "/nix/var/nix/profiles/" $$0}' - | xargs nvd diff

nix-flake-check:
	nix flake check

nix-garbage-collect:
	nix-collect-garbage -d
