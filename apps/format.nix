{ pkgs, ... }:
{
  # Source: https://github.com/nmasur/dotfiles
  # Prepare drive for nixos installation with impermanence in mind
  # Steps:
  # - import gpg public key from attached yubikey (required gpg-agent, etc.)
  # - run disko to partition the target drive (combines partitioning and filesystem declaration)
  # 

  type = "app";

  program = builtins.toString (pkgs.writeShellScript "format" ''
    set -e

    HOST=$(${pkgs.gum}/bin/gum choose "ignika" "teridax" "pewku")

    gpg --import ./users/skarmux/yubikey/public.gpg

    ${pkgs.disko}/bin/disko --mode disko --dry-run --flake "path:.#$HOST"
    ${pkgs.gum}/bin/gum confirm --default=false \
      "This will ERASE ALL DATA on dev/''${DISK}. Are you sure you want to continue?"
    sudo ${pkgs.disko}/bin/disko --mode disko --flake "path:$(pwd)#$HOST" \

<<<<<<< HEAD
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
=======
    # Reformat main partition to bcachefs
    ${pkgs.gum}/bin/gum log --time rfc822 --level debug "Unmountinx /nix partition"
>>>>>>> ed1ba89 (installation app)
    sudo umount -v /mnt/nix
    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Format bcachefs partition (again) with encryption and compression=lz4"
    sudo ${pkgs.bcachefs-tools}/bin/bcachefs format --encrypted --compression=lz4 /dev/sda2
    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Mount bcachefs partition to /mnt/nix"
    sudo mount -v $DISK /mnt/nix

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Create additional mount directories before install"
    sudo mkdir -v -p /mnt/{etc/nixos,etc/ssh,var/log}
    sudo mkdir -v -p /mnt/nix/persist/{etc/nixos,etc/ssh,var/log}

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Bind mount the persistent configuration / logs"
    sudo mount -v -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
    sudo mount -v -o bind /mnt/nix/persist/etc/ssh /mnt/etc/ssh
    sudo mount -v -o bind /mnt/nix/persist/var/log /mnt/var/log

  '');

}
