[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

https://github.com/nmasur/dotfiles
https://github.com/niksingh710/ndots
https://github.com/Misterio77/nix-config

# Updating

If the commit hash to nixpkgs after a `nix flake update nixpkgs` is too new so
that there are no cached binaries yet, you can replace it with the latest from
https://status.nixos.org: `nix flake lock --override-input github:nixos/nixpkgs/<commit_hash>`

Unfree or packages with overrides will always be built from source!

# Installation

```
# nix-shell
# sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake 'github:skarmux/nix-config#ignika' --disk main /dev/sdX
# ssh-keygen -t ed25519 -C "teridax" -f /mnt/etc/ssh/ssh_host_ed25519_key
```

# Install
```
nixos-install --flake .#teridax --no-root-passwd
```
When there is tmpfs mounted that is too small for the nix-build temporary files,
you can temporarily increase its size using remount:
```
mount -o remount,size=new_size /path/to/tmpfs
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

# PGP sign with Backup-Yubikey
Disable registered serial number from PGP key, to enable usage of the backup yubikey (obviously having a different serial number).
>gpg-connect-agent "scd serialno" "learn --force" /bye

[Source](https://security.stackexchange.com/questions/181551/create-backup-yubikey-with-identical-pgp-keys)

# Authenticate on GitHub for more generous API rate limit during nix builds
```
$ cat ~/.config/nix/nix.conf
access-tokens = github.com=<github api token>
```
