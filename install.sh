disko --mode disko --flake $1

mkdir -p /mnt/persist/etc/ssh
mkdir -p /mnt/persist/var/log
mkdir -p /mnt/persist/var/lib/{nixos,systemd/coredump}
mkdir -p /mnt/persist/home

mount --bind /mnt/persist/home /mnt/home
mount --bind /mnt/persist/var/log /mnt/var/log
mount --bind /mnt/persist/var/lib/nixos /mnt/var/lib/nixos
mount --bind /mnt/persist/var/lib/systemd/coredump /mnt/var/lib/systemd/coredump

# ssh-keygen -A -f /mnt/persist
# cp -r crypt-storage /mnt/boot/

nixos-install --no-root-password --flake $1
