#!/usr/bin/env bash

nix-shell https://github.com/sgillespie/nixos-yubikey-luks/archive/master.tar.gz

EFI_PART=/dev/sda1
LUKS_PART=/dev/sda2

SLOT=2
ykpersonalize -"$SLOT" -ochal-resp -ochal-hmac

SALT_LENGTH=16
salt="$(dd if=/dev/random bs=1 count=$SALT_LENGTH 2>/dev/null | rbtohex)"

challenge="$(echo -n $salt | openssl dgst -binary -sha512 | rbtohex)"
response="$(ykchalresp -2 -x $challenge 2>/dev/null)"

KEY_LENGTH=512
ITERATIONS=1000000

k_luks="$(echo | pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $response | rbtohex)"

EFI_MNT=/root/boot
mkdir "$EFI_MNT"
mkfs.vfat -F 32 -n uefi "$EFI_PART"
mount "$EFI_PART" "$EFI_MNT"

STORAGE=/crypt-storage/default
mkdir -p "$(dirname $EFI_MNT$STORAGE)"

echo -ne "$salt\n$ITERATIONS" > $EFI_MNT$STORAGE
CIPHER=aes-xts-plain64
HASH=sha512
echo -n "$k_luks" | hextorb | cryptsetup luksFormat --cipher="$CIPHER" \ 
  --key-size="$KEY_LENGTH" --hash="$HASH" --key-file=- "$LUKS_PART"

LUKSROOT=nixos-enc
echo -n "$k_luks" | hextorb | cryptsetup luksOpen $LUKS_PART $LUKSROOT --key-file=-

pvcreate "/dev/mapper/$LUKSROOT"

VGNAME=partitions
vgcreate "$VGNAME" "/dev/mapper/$LUKSROOT"

lvcreate -L 2G -n swap "$VGNAME"
FSROOT=fsroot
lvcreate -l 100%FREE -n "$FSROOT" "$VGNAME"

vgchange -ay

mkswap -L swap /dev/partitions/swap

mkfs.btrfs -L "$FSROOT" "/dev/partitions/$FSROOT"

mount "/dev/partitions/$FSROOT" /mnt

cd /mnt
btrfs subvolume create root
btrfs subvolume create persist
btrfs subvolume create nix

umount /mnt
mount -o subvol=root "/dev/partitions/$FSROOT" /mnt

mkdir /mnt/nix
mount -o subvol=nix "/dev/partitions/$FSROOT" /mnt/nix

mkdir /mnt/persist
mount -o subvol=persist "/dev/partitions/$FSROOT" /mnt/persist

mkdir /mnt/boot
mount "$EFI_PART" /mnt/boot

swapon /dev/partitions/swap
