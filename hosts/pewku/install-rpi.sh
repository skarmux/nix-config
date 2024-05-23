#!/usr/bin/env bash

export NIX_CONFIG="experimental-features = nix-command flakes"

#nix run github:nix-community/disko -- --mode disko --flake .#pewku

parted -a optimal /dev/sda -- mklabel gpt
parted -a optimal /dev/sda -- mkpart ESP fat32 1MiB 513MiB
parted -a optimal /dev/sda -- set 1 esp on
parted -a optimal /dev/sda -- mkpart primary 513MiB 100%

mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot 

nix-shell -p wget unzip git
cd /mnt/boot
wget https://github.com/pftf/RPi4/releases/download/v1.33/RPi4_UEFI_Firmware_v1.33.zip
unzip RPi4_UEFI_Firmware_v1.37.zip
rm -vi README.md
rm -vi RPi4_UEFI_Firmware_v1.37.zip
exit

# mkdir -v -p /mnt/{etc/nixos,etc/ssh,var/log,var/lib,srv}
# mkdir -v -p /mnt/nix/persist/{etc/nixos,etc/ssh,var/log,var/lib,srv}
#
# mount -v -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
# mount -v -o bind /mnt/nix/persist/etc/ssh /mnt/etc/ssh
# mount -v -o bind /mnt/nix/persist/var/log /mnt/var/log
# mount -v -o bind /mnt/nix/persist/var/lib /mnt/var/lib
# mount -v -o bind /mnt/nix/persist/srv /mnt/srv
#
# mount -v -o remount,size=2G /mnt
#
# cp -r ./** /mnt/etc/nixos && cd /mnt/etc/nixos
#
# mkdir -v -p /firmware
# mount -v /dev/mmcblk1p1 /firmware
# cp -v /firmware/* /mnt/boot
#
# nixos-install --flake .#pewku
