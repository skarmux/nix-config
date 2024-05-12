# Import public GPG key (linked with Yubikey) to .gnupg
```
gpg --import home/skarmux/device/yubikey/public.gpg
```

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
