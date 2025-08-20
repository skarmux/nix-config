{ pkgs, config, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/mnt/share" = {
    device = "//whenua/volume1";
    fsType = "cifs";
    options = let
      automount_opts = lib.concatStringsSep "," [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
      ];
    in [
      "ro,${automount_opts},credentials=${config.sops.secrets."whenua-smb".path},uid=${toString config.users.users.skarmux.uid}"
    ];
  };

  sops.secrets."whenua-smb" = {
    owner = "skarmux";
    mode = "400";
  };
}