{ inputs, lib, config, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/nix/persist" = {
    # Prevent the bind mounts from showing up
    # as mounted drives in the file manager.
    hideMounts = true;

    directories = [
      "/var/lib/systemd/coredump"
      "/var/log"
      "/etc/nixos"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  # Allow non-root users to specify the allow_other
  # or allow_root mount options, see mount.fuse3(8).
  # Allow root/sudo to see the /home mount
  programs.fuse.userAllowOther = true;

  # Give users ownership of their home directories.
  system.activationScripts.persistent-dirs.text = let
    mkHomePersist = user:
      lib.optionalString user.createHome ''
        mkdir -p /nix/persist/${user.home}
        chown ${user.name}:${user.group} /nix/persist/${user.home}
        chmod ${user.homeMode} /nix/persist/${user.home}
      '';
    users = lib.attrValues config.users.users;
  in
    lib.concatLines (map mkHomePersist users); 
}
