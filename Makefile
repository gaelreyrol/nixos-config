HOSTNAME = $(shell hostname)
USER = $(shell whoami)

system-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system

home-manager-diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/per-user/${USER}/home-manager

nixos-switch:
	nixos-rebuild switch --flake .#${HOSTNAME} --use-remote-sudo

nixos-upgrade:
	nixos-rebuild switch --upgrade --flake .#${HOSTNAME} --use-remote-sudo

nixos-build:
	nixos-rebuild build --flake .#${HOSTNAME}
	nvd diff /run/current-system ./result

nix-garbage-collect:
	nix-collect-garbage -d

pi0-deploy:
	nixos-rebuild switch -j auto --flake .#pi0 --build-host localhost --target-host lab@192.168.1.14 --use-remote-sudo -v

apu-deploy:
	nixos-rebuild switch -j auto --flake .#apu --build-host localhost --target-host router@192.168.1.19 --use-remote-sudo -v
