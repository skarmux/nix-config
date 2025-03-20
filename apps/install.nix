{ pkgs, ... }:
{
  type = "app";

  program = builtins.toString (pkgs.writeShellScript "install" ''
    set -e # exit on error

    # Sut up the Yubikey
    SLOT=2 # Short Press: Slot 1; Long Press: Slot 2
    ykpersonalize -"$SLOT" -ochal-resp -ochal-hmac
    SALT_LENGTH=16
    salt="$(dd af=/dev/random bs=1 count=$SALT_LENGHT 2>/dev/null | rbtohex)"
    challenge="$(echo -n $salt | openssl dgst -binary -sha512 | rbtohex)"
    response="$(ykchalresp -2 -x $challenge 2>/dev/null)"
    KEY_LENGTH=512
    ITERATIONS=1000000
    # Autheticate with password
    #read -s k_user
    #k_luks="$(echo -n $k_user | pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $response | rbtohex)"
    # Authenticate without password
    k_luks="$(echo | pbkdf2-sha512 $(($KEY_LENGTH / 8)) $ITERATIONS $response | rbtohex)"
    # Setup the LUKS partition
    EFI_PART=$(${pkgs.gum}/bin/gum input --placeholder "/dev/sdXp1")
    LUKS_PART=$(${pkgs.gum}/bin/gum input --placeholder "/dev/sdXp2")
    # Setup the LUKS device
    # Create the necessary filesystem on the efi system partition, which will store the current salt for the PBA, and mount it.
    EFI_MNT=/root/boot
    mkdir "$EFI_MNT"
    mkfs.vfat -F 32 -n uefi "$EFI_PART"
    mount "$EFI_PART" "$EFI_MNT"
    # Decide where on the efi system partition to store the salt and prepare the directore layout accordingly.
    STORAGE=/crypt-storage/default
    mkdir -p "$(dirname $EFI_MNT$STORAGE)"
    # Store the salt and iteration count to the EFI systems partition
    echo -ne "$salt\n$ITERATIONS" > $EFI_MNT$STORAGE
    # Create the LUKS device
    CIPHER=aes-xts-plain64
    HASH=sha512
    echo -n "$k_luks" | hextorb | cryptsetup luksFormat --cipher="$CIPHER" --key-size="$KEY_LENGTH" --hash="$HASH" --key-file=- "$LUKS_PART"

    # Preparing the disk

    cryptsetup luksFormat /dev/nvme0n1p2
    cryptsetup open /dev/nvme0n1p2 root
    mkfs.btrfs /dev/mapper/root
    sudo mount -t btrfs /dev/mapper/root /mnt

    lsblk
    DISK=$(${pkgs.gum}/bin/gum input --placeholder "/dev/sdX")
    HOST=$(${pkgs.gum}/bin/gum choose "ignika" "teridax" "pewku")

    log () {
      ${pkgs.gum}/bin/gum log --time rfc822 --level debug $1
    }

    log "Importing gpg key for attached yubikeys"
    gpg --import $(pwd)/users/skarmux/yubikey/public.gpg

    # All sops secrets are encrypted with the yubikey public gpg secret
    # so that host specific keys can be added at any time.
    log "Format disk"
    ${pkgs.gum}/bin/gum confirm --default=false \
      "This will ERASE ALL DATA on $DISK. Are you sure you want to continue?"
    nix --experimental-features "flakes nix-command" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake "path:$(pwd)#$HOST"

    # Reformat main partition to bcachefs
    log "Unmountinx /nix partition"
    umount -v /mnt/nix

    log "Format bcachefs partition (again) with encryption and compression=lz4"
    ${pkgs.bcachefs-tools}/bin/bcachefs format --encrypted --compression=lz4 $DISK


    log "Mount $DISK to /mnt/nix"
    mount -v $DISK /mnt/nix

    log "Create additional mount directories before install"
    mkdir -v -p /mnt/{etc/nixos,etc/ssh,var/log}
    mkdir -v -p /mnt/nix/persist/{etc/nixos,etc/ssh,var/log}

    log "Bind mount the persistent configuration / logs"
    mount -v -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
    mount -v -o bind /mnt/nix/persist/etc/ssh /mnt/etc/ssh
    mount -v -o bind /mnt/nix/persist/var/log /mnt/var/log

    # SSH
    log "Generate new host SSH keys"
    ssh-keygen -t ed25519 -C $HOST -f /mnt/etc/ssh/ssh_host_ed25519_key

    # AGE (required for sops-nix)
    AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age < /mnt/etc/ssh/ssh_host_ed25519_key.pub)
    log "Convert public SSH key to age format"
    echo $AGE_KEY

    # Update sops
    log "Replace old age key in .sops.yaml"
    sed -i "s/\&$HOST age.*/\&$HOST $AGE_KEY/" .sops.yaml

    log "Update secret encryption with new key (requires pgp key on yubikey)"
    ${pkgs.gum}/bin/gum confirm "YubiKey inserted?" --default=false
    ${pkgs.sops}/bin/sops updatekeys $(pwd)/machines/common/secrets.yaml

    ${pkgs.gum}/bin/gum confirm "Start installation?" --default=false
    nixos-install --flake $(pwd)#$HOST --no-root-passwd
  '');

}
