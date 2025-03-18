{ lib, inputs, ... }:
{
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "vfat";
  };

  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postResumeCommands = lib.mkAfter /* bash */ ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi
      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }
      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done
      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fc42a4c4-57cd-490a-b50d-6ead51c2834b";
    fsType = "btrfs";
    options = [ "subvol=root" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/fc42a4c4-57cd-490a-b50d-6ead51c2834b";
    fsType = "btrfs";
    options = [ "subvol=persist" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/fc42a4c4-57cd-490a-b50d-6ead51c2834b";
    fsType = "btrfs";
    options = [ "subvol=nix" "noatime" ];
  };

  # imports = [ inputs.disko.nixosModules.disko ];

  # # sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#ignika
  # disko.devices = {

  #   disk.main = {
  #     type = "disk";
  #     device = "/dev/nvme0n1"; # names can vary!!!
  #     content = {
  #       type = "gpt";
  #       partitions = {
  #         ESP = {
  #           size = "512M";
  #           type = "EF00";
  #           content = {
  #             type = "filesystem";
  #             format = "vfat";
  #             mountpoint = "/boot";
  #             mountOptions = [ "umask=007" ];
  #           };
  #         };
  #         # https://wiki.archlinux.org/title/Universal_2nd_Factor#Data-at-rest_encryption_with_LUKS
  #         luks = {
  #           size = "100%";
  #           content = {
  #             type = "luks";
  #             name = "crypted";
  #             # disable settings.keyFile if you want to use interactive password entry
  #             #passwordFile = "/tmp/secret.key"; # Interactive
  #             settings = {
  #               allowDiscards = true;
  #               keyFile = "/tmp/secret.key";
  #             };
  #             # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
  #             # mountpoint = "/root_vg";
  #             content = {
  #               type = "btrfs";
  #               extraArgs = [ "-f" ]; # Override existing partition
  #               subvolumes = {
  #                 "/root" = {
  #                   mountpoint = "/";
  #                   mountOptions = [ "compress=zstd" "noatime" ];
  #                 };
  #                 "/nix" = {
  #                   mountpoint = "/nix";
  #                   mountOptions = [ "compress-zstd" "noatime" ];
  #                 };
  #                 "/persist" = {
  #                   mountpoint = "/persist";
  #                   mountOptions = [ "compress-zstd" "noatime" ];
  #                 };
  #               };
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };

  # };

}
