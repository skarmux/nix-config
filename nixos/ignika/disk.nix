{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme1n1"; # FIXME names can vary!!!
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        main = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # Override existing partition
            # Subvolumes must set a mountpoinst on order to be mounted,
            # unless their parent is mounted
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = [ "compress-force=zstd:1" "noatime" "discard=async" "space_cache=v2" ];
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress-force=zstd:1" "noatime" "discard=async" "space_cache=v2" ];
              };
              "/persist" = {
                mountpoint = "/persist";
                mountOptions = [ "compress-force=zstd:1" "noatime" "discard=async" "space_cache=v2" ];
              };
            };
          };
        };
      };
    };
  };

  # Wipe root on boot
  # TODO: set correct paths to the subvolumes. remember there is luks encryption /dev/mapper/crypt
  # boot.initrd.postResumeCommands = lib.mkAfter ''
  #   mkdir /btrfs_tmp
  #   mount /dev/root_vg/root /btrfs_tmp
  #   if [[ -e /btrfs_tmp/root ]]; then
  #       mkdir -p /btrfs_tmp/old_roots
  #       timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #       mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #   fi
  #   delete_subvolume_recursively() {
  #       IFS=$'\n'
  #       for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #           delete_subvolume_recursively "/btrfs_tmp/$i"
  #       done
  #       btrfs subvolume delete "$1"
  #   }
  #   for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #       delete_subvolume_recursively "$i"
  #   done
  #   btrfs subvolume create /btrfs_tmp/root
  #   umount /btrfs_tmp
  # '';

}
