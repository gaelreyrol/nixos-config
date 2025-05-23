# nixos-config

[![Built with Nix](https://img.shields.io/badge/Built_With-Nix-5277C3.svg?logo=nixos)](https://builtwithnix.org/)
[![.github/workflows/ci.yml](https://github.com/gaelreyrol/nixos-config/actions/workflows/ci.yml/badge.svg)](https://github.com/gaelreyrol/nixos-config/actions/workflows/ci.yml)

## Setup

```bash
git clone git@github.com:gaelreyrol/nixos-config.git ~/.config/nix
cd ~/.config/nix
```

## Actions

### Build system

```bash
make nixos-build
```

### Switch system

```bash
make nixos-switch
```

### Garbage collect

```bash
make nix-garbage-collect
```

### Diff system & home-manager generations

```bash
make system-diff
make home-manager-diff
```

## Post actions

### Import Keybase keys

```bash
keybase pgp export -s | gpg --allow-secret-key-import --import
```

### Setup Yubikey challenge-response

```bash
ykman otp chalresp --touch --generate 2
ykpamcfg -2 -v
```

### Add a new host key to SOPS

```bash
# On user host
mkdir -p ~/.config/sops/age
ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt # Add output to .sops.yaml file
# On server host
cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age # Add output to .sops.yaml file

# Update secrets files with new keys
sops updatekeys secrets/default.yaml
```

## Credits

- <https://github.com/PierreZ/nixos-config>
- <https://gitlab.com/putchar/dotnix>
- <https://github.com/stefanDeveloper/nixos-lenovo-config>
- <https://github.com/hlissner/dotfiles>
- <https://github.com/Xe/nixos-configs>
- <https://github.com/jakehamilton/config>
- <https://github.com/drupol/nixos-x260>
