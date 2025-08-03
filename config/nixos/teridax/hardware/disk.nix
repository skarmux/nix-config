# Yubikey based Full Disk Encryption (FDE) on NixOS
# https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
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
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            # disable settings.keyFile if you want to use interactive password entry
            # passwordFile = "/tmp/secret.key"; # Interactive
            settings = {
              allowDiscards = true;
              keyFile = "/tmp/secret.key";
            };
            # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
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
                  # Allowing `atime` since I think it is linked to the cached shaders of Monster Hunter Wilds
                  # to be recognized as invalid when starting the game.
                  mountOptions = [ "compress-force=zstd:1" "discard=async" "space_cache=v2" ];
                };
              };
            };
          };
        };
      };
    };
  };

}
