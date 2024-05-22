{
  disko.devices = {

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=512M"
        "mode=755"
        "noexec"
      ];
    };

    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content.type = "gpt";
      content.partitions = {

        EFI = {
          size = "512M";
          type = "EF00"; # bootable
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };

        nixos = {
          size = "100%";
          end = "-4G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/nix";
          };
        };

        swap = {
          size = "100%";
          content = {
            type = "swap";
          };
        };

      };
    };
  };
}
