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
	rm -r result*
	nix-collect-garbage -d

nix-check:
	nix-store --verify --check-contents

nix-optimise:
	nix store optimise

nix-meta:
	nix-env -qa --meta --json '.*' > meta.json

gandi0-build:
	nix build .#nixosConfigurations.gandi0.config.system.build.vm |& nom

gandi0-run: gandi0-build
	export QEMU_NET_OPTS="hostfwd=tcp::2222-:22"
	./result/bin/run-gandi0-vm

pi0-deploy:
	nixos-rebuild switch -j auto --flake .#pi0 --target-host lab@192.168.1.14 --use-remote-sudo -v

apu-deploy:
	nixos-rebuild switch -j auto --flake .#apu --target-host router@192.168.1.19 --use-remote-sudo -v

clean:
	rm -r .direnv result*
	rm .envrc .pre-commit-config.yaml meta.json *.qcow2
