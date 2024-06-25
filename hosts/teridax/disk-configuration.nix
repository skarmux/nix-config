{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["size=4G"];
    };

    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content.type = "gpt";
      content.partitions = {

        ESP = {
          size = "500M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };

        nixos = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "bcachefs";
            mountpoint = "/nix";
          };
        };

      };
    };
  };
}
