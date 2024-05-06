{ pkgs, ... }:
{
  type = "app";

  program = builtins.toString (pkgs.writeShellScript "mount" ''
    set -e

    HOST=$1
    DISK=$2

    export NIX_CONFIG="experimental-features = nix-command flakes"

    sudo ${pkgs.disko}/bin/disko --mode mount --flake "path:$(pwd)#''$HOST"

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Bind mount the persistent configuration / logs"
    sudo mount -v -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
    sudo mount -v -o bind /mnt/nix/persist/etc/ssh /mnt/etc/ssh
    sudo mount -v -o bind /mnt/nix/persist/var/log /mnt/var/log
  '');

}
