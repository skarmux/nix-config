#!/usr/bin/env bash

HOST=$1

export NIX_CONFIG="experimental-features = nix-command flakes"

nix run github:nix-community/disko -- --mode disko --flake .#$HOST

mkdir -v -p /mnt/{etc/nixos,etc/ssh,var/log,var/lib,srv}
mkdir -v -p /mnt/nix/persist/{etc/nixos,etc/ssh,var/log,var/lib,srv}

mount -v -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
mount -v -o bind /mnt/nix/persist/etc/ssh /mnt/etc/ssh
mount -v -o bind /mnt/nix/persist/var/log /mnt/var/log
mount -v -o bind /mnt/nix/persist/var/lib /mnt/var/lib
mount -v -o bind /mnt/nix/persist/srv /mnt/srv

mount -v -o remount,size=2G /mnt

cp -r ./** /mnt/etc/nixos && cd /mnt/etc/nixos

mkdir -v /firmware
mount -v /dev/mmcblk0p1 /firmware
cp -v /firmware/* /mnt/boot

nixos-install --flake .#$HOST
