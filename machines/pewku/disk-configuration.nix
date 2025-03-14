{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {

    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content.type = "gpt";
      content.partitions = {

        ESP = {
          size = "512M";
          type = "EF00"; # bootable
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };

        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };

      };
    };
  };
}
