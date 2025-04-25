{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        # We need a specific boot partition for Raspberry Pi 4
        # to allow booting from USB, where the SSD is attached.
        # It must start at 1MiB
        ESP = {
          type = "EF00"; # may not work
          start = "1MiB";
          end = "513MiB";
          content = {
            type = "filesystem";
            format = "fat32";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            # disable settings.keyFile if you want to use interactive password entry
            passwordFile = "/tmp/disk-main.key"; # see nixos-anywhere.sh
            settings = { allowDiscards = true; };
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # Override existing partition
              # `noatime` (No Access Time) disables the writing of the last access time on files/directories.
              # It reduces writes and therefore increases performance and disk longevity.
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };

}
