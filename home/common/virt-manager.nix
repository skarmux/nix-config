{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  home-manager.users.skarmux = {
    # Automatically establish virtio network bridge at boot
    # It is significantly faster than `e1000e`
    dconf.settings = mkIf config.programs.virt-manager.enable {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
