{ pkgs, ... }: {
  home.packages = [ pkgs.virt-manager ];

  # Automatically establish virtio network bridge at boot
  # It is significantly faster than `e1000e`
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
