{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["size=4G"];
    };

    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/some-disk-id";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "500M";
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
  };
}
