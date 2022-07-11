# nixos-config

## Setup

```bash
git clone git@github.com:gaelreyrol/nixos-config.git ~/.config/nix
cd ~/.config/nix
```

## Actions

### Switch

```bash
sudo make nixos-switch
```

### Upgrade

```bash
sudo make nixos-upgrade
```

### Import Keybase keys

```bash
keybase pgp export -s | gpg --allow-secret-key-import --import
```

## Credits

- https://github.com/PierreZ/nixos-config
- https://gitlab.com/putchar/dotnix
- https://github.com/stefanDeveloper/nixos-lenovo-config