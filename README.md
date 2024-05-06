# Enable experimental features on installation media
```
export NIX_CONFIG="experimental-features = nix-command flakes"
```

# Prepare drives with Disko
```
nix run github:nix-community/disko -- --mode disko --flake github:skarmux/nix-config#teridax 
```

# Unmount and reformat bcachefs partition with encryption and compression
```
umount /mnt/nix
bcachefs --encrypted --compression=lz4 /dev/sda2
# ... set password
mount /dev/sda2 /mnt/nix
# ... enter password
```

# Create additional mount directories
```
mkdir -v -p /mnt/{etc/nixos,var/log,etc/ssh}
```
# Create persistent directories
```
mkdir -v -p /mnt/nix/persist/{etc/nixos,var/log,etc/ssh}
```

# Bind mount the persistent configuration / logs
```
mount -v -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
```
```
mount -v -o bind /mnt/nix/persist/var/log /mnt/var/log
```
```
mount -v -o bind /mnt/nix/persist/etc/ssh /mnt/etc/ssh
```

# Create new SSH keys
```
ssh-keygen -t ed25519 -C "teridax" -f /mnt/etc/ssh/ssh_host_ed25519_key
```

# Make config directory temporarily easier to work with
```
chmod -v 777 /mnt/etc/nixos
```

# Pull repository
```
git clone https://github.com/skarmux/nix-config.git /mnt/etc/nixos && cd /mnt/etc/nixos
```

# Enter development shell (for access do requided tools)
```
nix develop

ssh-to-age < /mnt/etc/ssh/ssh_host_ed25519_key.pub
# put that age key into .sops.yaml
sops updatekeys **/secrets.yaml
```

# Install
```
nixos-install --flake .#teridax --no-root-passwd
```
# Change /mnt/etc/nixos permissions back
```
chmod -v 755 /mnt/etc/nixos
```

# GPG & SSH
## Import public GPG key ´public.pgp´
Enter the root of this repository and call ´gpg --import public.pgp´.
This public PGP key holds a reference to the Primary Yubikey (serial no.) in order to access the private key and encryption features.
TODO: In order to use the secondary Yubikey (holding the same PGP private key), the serial number within the public key must be explicitly ignored.
## Residential SSH Key (Inserted Yubikey)
Temporary: ´ssh-add -K´
Permanent: ´ssh-keygen -K´
Temporary is better. That way, it doesn't matter if the Primary or Secondary Yubikey is being used after rebooting.

## Configure GPG Signing for Git
Instruct GPG to use TTY for password entry during signing. Alacritty is not capable of displaying the dialog.
Pinentry can be done via TTY (always works) or with curses (?) via GUI.
```
export GPG_TT=$(tty)
```

Git is using the gpg binary found in $PATH. Therefore add the gpg version installed by nix to the $PATH.
```
export PATH="/nix/store/8gdfyd2b2i96v0691ff29i2xfhrnwi8b-gnupg-2.4.0/bin/gpg:$PATH"
```

# Docker
Docker can't connect to daemon when installed using home-manager. Linux post-install steps:
```
<!-- sudo groupadd docker -->
<!-- sudo usermod -aG docker $USER -->
<!-- newgrp docker -->
sudo dockerd --data-root /home/deck/.docker-store -G deck
```

# PGP sign with Backup-Yubikey
Disable registered serial number from PGP key, to enable usage of the backup yubikey (obviously having a different serial number).
>gpg-connect-agent "scd serialno" "learn --force" /bye

[Source](https://security.stackexchange.com/questions/181551/create-backup-yubikey-with-identical-pgp-keys)

# Authenticate on GitHub for more generous API rate limit during nix builds
```
$ cat ~/.config/nix/nix.conf
access-tokens = github.com=<github api token>
```
