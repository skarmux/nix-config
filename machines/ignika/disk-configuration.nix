{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {

    # TODO Force swapfile so the system does not crash
    #      on out-of-memory situations
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
          MBR = {
            type = "EF02"; # for grub MBR
            size = "1M";
            priority = 1; # Needs to be first partition
          };
          ESP = {
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
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
