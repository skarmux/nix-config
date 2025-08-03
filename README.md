[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

# Installation

## Live image

### Generating a custom live image

Use a nix-enabled system to generate a live image (for a given machine). Since we need at least `disko` and `sops` to set everything up, we're gonna need a customized live image to boot from, that has the binaries for those two already built. If we were to install them in-place on the live system, the ram filesystem might exceed its limits when a build triggers, dependencies get pulled and lots of C++ gets compiled.

TODO: I'm considering adding an authentication manager to the live image, that allows for use of my yubikeys which store resident ssh keys (the private key file is a mere handle for the real private key living on the yubikey hardware). Those I could import with something like `ssh-keygen -K` and then use those keys to unlock the sops secrets.

The nixos configuration for the live image is declared in `nixos/default.nix`. Add packages at will. I'll be happy with `disko`, `sops` + `age` & `helix` as a bare minimum.

Build the image:
```sh
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

The resulting image can be found in `result/iso`.

### Booting into live image

- Pull the latest version if THIS repository.
- Prepare the drive using the disko configuration.
- 

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

## Remote setup with `disko` and `nixos-anywhere`

 - How do I get sops setup with a private host ssh key? Can I import a pre-determined private key?
 - I need a custom `kexec` image for deploying on any architecture other than `x86_64`.

```
 # Example for deployment on `pewku`

nix run github:nix-community/nixos-anywhere -- \
 --kexec "$(nix build --print-out-paths github:nix-community/nixos-images#packages.aarch64-linux.kexec-installer-nixos-unstable-noninteractive)/nixos-kexec-installer-noninteractive-aarch64-linux.tar.gz" \
 --flake 'github:skarmux/nix-config#pewku' \
 skarmux@pewku
```
- Command must be run by a machine able to compile aarch64 natively, with a remote builder or qemu.
  - I use qemu on my NixOS with `boot.binfmt.emulatedSystems = [ "aarch64-linux" ];`
- Can I do this with a sudoers user instead of root?
  - `A target machine that is reachable via SSH, either using keys or a password, and the privilege to either log in directly as root or a user with password-less sudo.`
  - I think skarmux is configured for password-less sudo?


# Updating

## Going back a commit to pull the latest cached binaries

If the commit hash to nixpkgs after a `nix flake update nixpkgs` is too new so
that there are no cached binaries yet, you can replace it with the latest from
https://status.nixos.org: `nix flake lock --override-input github:nixos/nixpkgs/<commit_hash>`

Unfree or packages with overrides will always be built from source!

# Change /mnt/etc/nixos permissions back
```
chmod -v 755 /mnt/etc/nixos
```

# SOPS

Host ssh keys are being used to decrypt sops secrets at runtime.

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

# Credit

- https://github.com/nmasur/dotfiles
- https://github.com/niksingh710/ndots
- https://github.com/Misterio77/nix-config
