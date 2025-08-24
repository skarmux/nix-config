{ pkgs, config, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/mnt/share" = {
    device = "//whenua/crypt";
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
      "${automount_opts},credentials=${config.sops.secrets."whenua-smb".path}"
    ];
  };

  # networking.firewall.extraCommands = ''
  #   iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
  # '';

  sops.secrets."whenua-smb" = {
    # owner = "skarmux";
    # mode = "400";
  };
}