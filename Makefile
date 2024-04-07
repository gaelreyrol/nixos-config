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
	nixos-rebuild build --flake .#${HOSTNAME} |& nom
	nvd diff /run/current-system ./result

nix-purge:
	nix-collect-garbage -d

nix-check:
	nix-store --verify --check-contents

nix-optimise:
	nix store optimise

nix-meta:
	nix-env -qa --meta --json '.*' > meta.json

pi0-deploy:
	nixos-rebuild switch -j auto --flake .#pi0 --target-host lab@192.168.1.14 --use-remote-sudo -v

apu-deploy:
	nixos-rebuild switch -j auto --flake .#apu --target-host router@192.168.1.19 --use-remote-sudo -v

iso:
	nix build .#nixosConfigurations.iso.config.system.build.isoImage
