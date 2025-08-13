{ lib, config, pkgs, ... }:
# Sources:
# https://nixos.wiki/wiki/Virt-manager
# https://christitus.com/windows-inside-linux/
# https://christitus.com/vm-setup-in-linux/
#
# Downloads:
# [Win10] https://software.download.prss.microsoft.com/dbazure/Win10_22H2_German_x64v1.iso
# -> /var/lib/libvirt/images/<here>
# [VirtIO] https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso
#
# TODO: Networking
# The default network starts off as being inactive, you must enable it before it is accessible.
# This can be done by running the following command:
# $ virsh net-start default
# Or autostart:
# $ virsh net-autostart default
# By default this will enable the virbr0 virtual network bridge.
{
  programs.virt-manager.enable = true;

  boot = {
    kernelModules = [ "kvm-intel" ];

    initrd.kernelModules = [
      "vfio"
      # "vfio_pci"
      # "vfio_iommu_type1"
    ];

    kernelParams = [
      # "amd_iommu=on"
      # "iommu=pt" # grub safety reasons... FIXME: I'm now using systemd boot
    ];
  };

  users = {
    users.skarmux.extraGroups = [ "libvirtd" ];
    groups.libvirtd.members = [ "skarmux" ];
  };

  virtualisation.libvirtd = {
    enable = true;

    onBoot = "ignore";
    onShutdown = "shutdown";

    qemu.ovmf.enable = true;
    qemu.runAsRoot = true;
  };

}
