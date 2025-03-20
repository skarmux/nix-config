#!/usr/bin/env bash

mkdir -p /mnt/persist/{etc/ssh,etc/nixos,var/log}
mkdir -p /mnt/{etc/ssh,etc/nixos,var/log}

mount -o bind /mnt/persist/etc/ssh /mnt/etc/ssh
mount -o bind /mnt/persist/etc/nixos /mnt/etc/nixos
mount -o bind /mnt/persist/var/log /mnt/var/log

ssh-keygen -t ed25519 -C ignika -f /mnt/etc/ssh/ssh_host_ed25519_key

export GPG_TTY=`tty`
echo "pinentry-program $(which pinentry-cursus)" >> ~/.gnupg/gpg-agent.conf

