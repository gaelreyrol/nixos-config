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