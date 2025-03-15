{ pkgs, ... }:
{
  # Source: https://github.com/nmasur/dotfiles

  type = "app";

  program = builtins.toString (pkgs.writeShellScript "format" ''
    set -e

    HOST=$1
    DISK=$2

    export NIX_CONFIG="experimental-features = nix-command flakes"

    gpg --import $(pwd)/home/skarmux/yubikey/public.gpg

    ${pkgs.disko}/bin/disko \
        --mode disko \
        --dry-run \
        --flake "path:$(pwd)#$HOST" \

    ${pkgs.gum}/bin/gum confirm \
        "This will ERASE ALL DATA on dev/''${DISK}. Are you sure you want to continue?" \
        --default=false

    sudo ${pkgs.disko}/bin/disko \
        --mode disko \
        --flake "path:$(pwd)#teridax" \

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Unmount bcachefs partition"
    sudo umount -v /mnt/nix

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Format bcachefs partition (again) with encryption and compression=lz4"
    sudo ${pkgs.bcachefs-tools}/bin/bcachefs format --encrypted --compression=lz4 /dev/sda2

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Mount bcachefs partition to /mnt/nix"
    sudo mount -v /dev/sda2 /mnt/nix

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Create additional mount directories"
    sudo mkdir -v -p /mnt/{etc/nixos,etc/ssh,var/log}
    sudo mkdir -v -p /mnt/nix/persist/{etc/nixos,etc/ssh,var/log}

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Bind mount the persistent configuration / logs"
    sudo mount -v -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
    sudo mount -v -o bind /mnt/nix/persist/etc/ssh /mnt/etc/ssh
    sudo mount -v -o bind /mnt/nix/persist/var/log /mnt/var/log

  '');

}
