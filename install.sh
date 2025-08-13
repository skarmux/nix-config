#!/usr/bin/env bash

# This is not meant to be executed but rather to
# have the steps necessary for an installation
# documented an a straight-forward way.

# Connect to wifi
# nmcli device wifi
# nmcli device wifi connect <SSID> --ask

# cp luks.key /tmp/luks.key

disko --mode disko --flake $1

mkdir -p /mnt/persist/etc/ssh
mkdir -p /mnt/persist/var/log
mkdir -p /mnt/persist/var/lib/{nixos,systemd/coredump}
mkdir -p /mnt/persist/home

mkdir -p /mnt/etc/ssh
mkdir -p /mnt/var/log
mkdir -p /mnt/var/lib/{nixos,systemd/coredump}
mkdir -p /mnt/home

mount --bind /mnt/persist/etc/ssh /mnt/etc/ssh
mount --bind /mnt/persist/var/log /mnt/var/log
mount --bind /mnt/persist/var/lib/nixos /mnt/var/lib/nixos
mount --bind /mnt/persist/var/lib/systemd/coredump /mnt/var/lib/systemd/coredump
mount --bind /mnt/persist/home /mnt/home

# ssh-keygen -A -f /mnt/persist

# read/write for the owner (root)
# chmod 600 /mnt/persist/etc/ssh/ssh_host*
# chmod 644 /mnt/persist/etc/ssh/ssh_host*.pub

# cp -r crypt-storage /mnt/boot/

nixos-install --no-root-password --flake $1
