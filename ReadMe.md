# nixos-config

## Switch

```bash
git clone git@github.com:gaelreyrol/nixos-config.git ~/.config/nix
cd ~/.config/nix
sudo nixos-rebuild switch -I nixos-config=./configuration.nix -p main
```

## Keybase

```bash
keybase pgp export -s | gpg --allow-secret-key-import --import
```

## Credits

- https://github.com/PierreZ/nixos-config
- https://gitlab.com/putchar/dotnix
- https://github.com/stefanDeveloper/nixos-lenovo-config