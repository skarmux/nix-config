{ config, pkgs, lib, ... }: {
  # The user id has to be the same as the one for the corresponding
  # user on synology nas, which is (in this case) fixed to '1026'.
  # That way the permission settings of NFS-mounted folder match!
  users.users."skarmux".uid = 1026;

  # Required by NFS
  services.rpcbind.enable = true;

  # NFS mounts
  systemd.mounts = let
    commonMountOptions = {
      type = "nfs";
      mountConfig = {
        Options = [
          "noatime" # disable writing file-access times to files
          "rw"
          "users" # TODO: maybe don't allow all users to access?
          "vers=4"
          "minorversion=1" # highest supported protocol by synology nas
        ];
      };
    };
  in [
    # Connect to whenua (synology nas) via local network IP and
    # via tailscale network (machine name: whenua) as fallback
    (commonMountOptions // {
      what = "whenua:/volume1/games";
      where = "/nfs/games";
    })
    (commonMountOptions // {
      what = "whenua:/volume1/videos";
      where = "/nfs/videos";
    })
    (commonMountOptions // {
      what = "whenua:/volume1/photos";
      where = "/nfs/photos";
    })
    (commonMountOptions // {
      what = "whenua:/volume1/ebooks";
      where = "/nfs/ebooks";
    })
  ];

  # Auto-mounts
  systemd.automounts = let
    commonAutoMountOptions = {
      wantedBy = [ "multi-user.target" ];
      automountConfig = { TimeoutIdleSec = "600"; };
    };
  in [
    (commonAutoMountOptions // { where = "/nfs/games"; })
    (commonAutoMountOptions // { where = "/nfs/videos"; })
    (commonAutoMountOptions // { where = "/nfs/photos"; })
    (commonAutoMountOptions // { where = "/nfs/ebooks"; })
  ];
}
