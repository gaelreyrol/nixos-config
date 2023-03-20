# nixos-config

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
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

## Credits

- https://github.com/PierreZ/nixos-config
- https://gitlab.com/putchar/dotnix
- https://github.com/stefanDeveloper/nixos-lenovo-config
- https://github.com/hlissner/dotfiles
- https://github.com/Xe/nixos-configs
- https://github.com/jakehamilton/config
- https://github.com/drupol/nixos-x260