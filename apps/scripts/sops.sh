#!/usr/bin/env bash

HOST=$(gum choose "ignika" "teridax" "pewku")

# Generate SSH key
mkdir -p /mnt/persist/etc/ssh
ssh-keygen -t ed25519 -C "$HOST" -f /mnt/etc/ssh/ssh_host_ed25519_key

# Follow up with `sops updatekeys machines/common/secrets.yaml` after updating
# the age key for $HOST in .sops.yaml. `ssh-to-age /mnt/etc/ssh/ssh_host_ed25519_key.pub`
AGE_KEY=$(ssh-to-age < /mnt/etc/ssh/ssh_host_ed25519_key.pub)

# Import gpg key (private key stored on yubikey)
gpg --import users/skarmux/yubikey/public.gpg

# Fix pinentry
export GPG_TTY=$(tty)
mkdir -p ~/.gnupg
echo "pinentry-program $(which pinentry-curses)" >> ~/.gnupg/gpg-agent.conf

# Replace old age key in .sops.yaml
sed -i "s/\&$HOST age.*/\&$HOST $AGE_KEY/" .sops.yaml

# Update secret encryption with new key
sops updatekeys machines/common/secrets.yaml
