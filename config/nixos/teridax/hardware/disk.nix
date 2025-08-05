{ config, ... }:
# (1) Yubikey based Full Disk Encryption (FDE) on NixOS
# https://nixos.wiki/wiki/Yubikey_based_Full_Disk_Encryption_(FDE)_on_NixOS
# (2) Disko example: Btrfs + Luks
# https://github.com/nix-community/disko/blob/master/example/luks-btrfs-subvolumes.nix
# (3) Disko Luks definition:
# https://github.com/nix-community/disko/blob/545aba02960caa78a31bd9a8709a0ad4b6320a5c/lib/types/luks.nix#L11
{
  boot.initrd = {
    # Minimal list of modules to use the EFI system partition and the YubiKey
    kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];
    # Enable support for the YubiKey PBA
    luks = {
      yubikeySupport = true;
      devices."crypted" = {
        device = "/dev/sda2";
        preLVM = true; # You may want to set this to false if you need to start a network service first
        # NOTE: This could not be placed within [...].luks.content.settings since all those entries
        #       are coerced as strings and attribute sets are not convertible to string.
        yubikey = {
          slot = 1;
          twoFactor = true; # Set to false if you did not set up a user password.
          storage = {
            path = "/crypt-storage/default";
            fsType = "vfat"; # same as ESP
            # An unencrypted device that will temporarily be mounted in stage-1.
            # Must contain the current salt to create the challenge for this LUKS device.
            device = "/dev/sda1"; # Should be /dev/sda1
          };
        };
      };
    };
  };

  disko.devices.disk."main" = {
    type = "disk";
    # Pass device name to config from disko command
    # disko --arg name value
    # disko --argstr name value
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        # efi system partition
        # - stores current salt for PBA (Pre-Boot Authentication)
        # TODO: How do I store salt and iterations count on the efi partition

        # $ EFI_MNT=/boot
        # $ STORAGE=/crypt-storage/default
        # $ mkdir -p "$(dirname $EFI_MNT$STORAGE)"
        # $ echo -ne "$salt\n$ITERATIONS" > $EFI_MNT$STORAGE
        
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            # if ! (blkid "${config.device}" | grep -q 'TYPE='); then
            #   mkfs.${config.format} \
            #     ${lib.escapeShellArgs config.extraArgs} \
            #     "${config.device}"
            # fi
            # extraArgs = ;
            mountOptions = [ "umask=0077" ];
            mountpoint = "/boot";
            format = "vfat";
          };
        };
        # luks device
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            # NOTE: Disable settings.keyFile if you want to use interactive password entry
            # Path to the file which contains the password for initial encryption
            # passwordFile = "/tmp/secret.key"; # Interactive

            # Path to the file which contains the password for initial encryption
            # passwordFile = ;

            # Whether to ask for a password for initial encryption
            # `true` when there is no keyFile
            # askPassword = ;

            # LUKS settings (as defined in configuration.nix in boot.initrd.luks.devices.<name>)
            settings = {
              allowDiscards = true;
              # TODO: keyfile should contain the raw binary of the $k_luks (1)
              # keyfile is only used for initial encryption
              keyFile = "/tmp/luks.key"; # `--key-file ${keyFile}`
            };

            # Path to additional key files for encryption
            # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];

            # Whether to add a boot.initrd.luks.devices entry for the specified disk.
            initrdUnlock = true; # default: true

            # [NixOS Wiki]
            # Step 9: Create the LUKS device
            #
            # rbtohex: Convert a raw binary string to a hexadecimal string
            # hextorb: Convert a hexadecimal string to a raw binary string
            #
            # echo -n "$k_luks" | hextorb | cryptsetup luksFormat --cipher="$CIPHER" \ 
            #   --key-size="$KEY_LENGTH" --hash="$HASH" --key-file=- "$LUKS_PART"

            # [Disko]
            # Uses `-q` flag on cryptsetup
            # -q, --batch-mode :: Do not ask for confirmation
            #
            # [manpage]
            # cryptsetup <opt> luksFormat <device> [<new key file>] - formats a LUKS device
            #
            # cryptsetup -q luksFormat "${config.device}" \
            # ${toString config.extraFormatArgs} ${keyFileArgs}

            # Extra arguments to pass to `cryptsetup luksFormat` when formatting
            # TODO: Can I pass secret values with the `disko` command?
            extraFormatArgs = [
              "--cipher aes-xts-plain64"
              "--key-size 512" # KEY_LENGTH
              "--hash sha512"
              # "--key-file=-" # Make this replace ${keyFileArgs} NOTE: I used `settings.keyFile = "-";`
            ];

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
