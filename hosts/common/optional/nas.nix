{ ... }:
let
  whenua_ip = "192.168.178.22";
in
{
  # Required for NFS
  services.rpcbind.enable = true;
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/whenua" = {
    device = "${whenua_ip}:/volume1/skarmux";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"

      # Lazy-mounting
      "x-systemd.automount"
      "noauto"

      # Auto-disconnecting after 10 min
      "x-systemd.idle-timeout=600"
      
      # boot when server is not reachable
      "nofail" 
      # "user.noauto"

      "user=skarmux"
      # "users 0 0"

      # Hide mount point
      # "x-gvfs-hide"
    ];
  };

}
