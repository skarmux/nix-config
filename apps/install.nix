{ pkgs, ... }:
{
  # Source: https://github.com/nmasur/dotfiles

  type = "app";

  program = builtins.toString (pkgs.writeShellScript "install" ''
    set -e

    HOST=$1
    DISK=$2

    export NIX_CONFIG="experimental-features = nix-command flakes"

    gpg --import $(pwd)/home/skarmux/yubikey/public.gpg

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Generate new host SSH keys"
    sudo ssh-keygen -t ed25519 -C $HOST -f /mnt/etc/ssh/ssh_host_ed25519_key

    AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age < /mnt/etc/ssh/ssh_host_ed25519_key.pub)
    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Convert public SSH key to age format"
    echo $AGE_KEY

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Replace old age key in .sops.yaml"
    sed -i "s/\&$HOST age.*/\&$HOST $AGE_KEY/" $(pwd)/.sops.yaml

    ${pkgs.gum}/bin/gum log --time rfc822 --level debug \
      "Update secret encryption with new key (requires pgp key on yubikey)"
    ${pkgs.gum}/bin/gum confirm "YubiKey inserted?" --default=false
    ${pkgs.sops}/bin/sops updatekeys $(pwd)/hosts/common/secrets.yaml

    sudo cp -a $(pwd)/. /mnt/etc/nixos/
    sudo chmod -v 777 /mnt/etc/nixos

    ${pkgs.gum}/bin/gum confirm "Start installation?" --default=false
    sudo nixos-install --flake /mnt/etc/nixos#$HOST --no-root-passwd

    sudo chmod -v -R 755 /mnt/etc/nixos
  '');

}
