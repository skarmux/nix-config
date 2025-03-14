{ lib, inputs, config, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options = {
    persistDir = lib.mkOption {
      type = lib.types.str;
      default = "/nix/persist";
      example = "/persist";
      description = "Root directory for persisting data on the filesystem.";
    };
  };

  config = {
    environment.persistence = {
      "${config.persistDir}" = {

        # Prevent the bind mounts from showing up
        # as mounted drives in the file manager.
        hideMounts = true;

        directories = [
          "/var/lib/systemd/coredump"
          "/var/lib/nixos" # store user ids
          "/var/log" # store logs in-between boots for bootup crash analysis
          "/etc/nixos"
          "/etc/ssh"
        ];

        files = [
          # TODO: nixos-rebuild keeps regenerating the machine id before
          # attempting the bind mount on host pewku, and therefore errors...
          # "/etc/machine-id"
        ];
      };
    };

    # Allow non-root users to specify the allow_other
    # or allow_root mount options, see mount.fuse3(8).
    # Allow root/sudoers to see /home mounts
    programs.fuse.userAllowOther = true;

    # Give users ownership of their home directories.
    system.activationScripts = {
      persistent-dirs = {
        text = let
          mkHomePersist = user:
            lib.optionalString user.createHome ''
              mkdir -p "${config.persistDir}${user.home}"
              chown ${user.name}:${user.group} "${config.persistDir}${user.home}"
              chmod ${user.homeMode} "${config.persistDir}${user.home}"
            '';
          users = lib.attrValues config.users.users;
        in
          lib.concatLines (map mkHomePersist users);
      };
    };
  };
}
