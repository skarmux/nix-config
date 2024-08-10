# Install nix (multi-user)
```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

# Import public GPG key (linked with Yubikey) to .gnupg
```
gpg --import home/skarmux/device/yubikey/public.gpg
```

# Install Decky Plugin Manager for Steam Deck
```
curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
```

# Change user shell for `deck` to `fish`
```
chsh -s /usr/bin/fish deck
```
Change goes into effect after rebooting.

# Auto-load XDG_DATA_DIR
```
cp ./nix-datadir.sh /etc/profile.d/nix-datadir.sh
chown root:root /etc/profile.d/nix-datadir.sh
```

# Add `hyprland.sh` as Non-Steam game.

# After every reboot in order to use nix commands like `nix develop`
```
sudo systemctl enable nix-daemon --now
```

# Switch to SSH after loading the public SSH keys via `home-manager switch`
```
git remote set-url git@github.com:skarmux/nix-config.git
```

sops-nix cannot unlock the Yubikey (PIN entry) on start the pinentry dialogue won't open
on home-manage switch. A workaround is to unlock the Yubikey with sops path/to/secrets.yaml
first and call home-manager switch afterwards.

Steam input cannot pass the SUPER key for key combinations. Therefore hyprland needs to use
`Alt_L` or any other key other than `SUPER/WIN` as mod key.
