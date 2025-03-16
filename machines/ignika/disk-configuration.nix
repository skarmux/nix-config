{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    postDeviceCommands = lib.mkIf (!phase1Systemd) (lib.mkBefore wipeScript);
    systemd.services.restore-root = lib.mkIf phase1Systemd {
      description = "Rollback btrfs rootfs";
      wantedBy = [ "initrd.target" ];
      requires = [ "dev-disk-by\\x2dlabel-${config.networking.hostName}.device" ];
      after = [
        "dev-disk-by\\x2dlabel-${config.networking.hostName}.device" 
        "systemd-croptsetop@${config.networking.hostName}.service"
      ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = wipeScript;
    };

    boot.initrd.postResumeCommands = lib.mkAfter /* bash */ ''
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

  disko.devices = {

    disk.main = {
      type = "disk";
      device = "/dev/sdX";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=007" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              # disable settings.keyFile if you want to use interactive password entry
              #passwordFile = "/tmp/secret.key"; # Interactive
              settings = {
                allowDiscards = true;
                keyFile = "/tmp/secret.key";
              };
              additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = { "compress-zstd" "noatime" };
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = { "compress-zstd" "noatime" };
                  };
                };
              };
            };
          };
        };
      };
    };

  };

}
