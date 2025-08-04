# Yubikey based Full Disk Encryption (FDE) on NixOS
# https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS
#
# Disko example: Btrfs + Luks
# https://github.com/nix-community/disko/blob/master/example/luks-btrfs-subvolumes.nix
# Disko Luks definition:
# https://github.com/nix-community/disko/blob/545aba02960caa78a31bd9a8709a0ad4b6320a5c/lib/types/luks.nix#L11
let
  luks_root = "crypted";
in
{
  boot.initrd = {
    # Minimal list of modules to use the EFI system partition and the YubiKey
    kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];

    # Enable support for the YubiKey PBA
    luks.yubikeySupport = true;

    # Configuration to use your Luks device
    luks.devices = {
      "${luks_root}" = {
        device = "/dev/sda2";
        preLVM = true; # You may want to set this to false if you need to start a network service first
        yubikey = {
          slot = 1;
          twoFactor = true; # Set to false if you did not set up a user password.
          storage = {
            device = "/dev/sda1";
          };
        };
      }; 
    };
  };

  disko.devices.disk."main" = {
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
            name = "${luks_root}";
            # disable settings.keyFile if you want to use interactive password entry
            # TODO: "interactive" during boot or disko install?
            
            # Path to the file which contains the password for initial encryption
            # passwordFile = "/tmp/secret.key"; # Interactive

            # LUKS settings (as defined in configuration.nix in boot.initrd.luks.devices.<name>)
            settings = {
              allowDiscards = true;
              keyFile = "/tmp/secret.key";
            };

            # Path to additional key files for encryption
            # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];

            # Whether to add a boot.initrd.luks.devices entry for the specified disk.
            initrdUnlock = true;

            # Extra arguments to pass to `cryptsetup luksFormat` when formatting
            extraFormatArgs = [ ];

            # Extra arguments to pass to `cryptsetup luksOpen` when opening
            extraOpenArgs = [ ];

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
