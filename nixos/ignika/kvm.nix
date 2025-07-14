# https://nixos.wiki/wiki/Virt-manager
{ lib, pkgs, ... }: {
  boot = {
    kernelModules = [ "kvm-amd" ];

    # Order in list is execution order
    # Assure vfio modules get loaded before nvidia/amd
    initrd.kernelModules = lib.mkBefore [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      # ...
      # nvidia
    ];

    kernelParams = [
      "amd_iommu=on"
      "iommu=pt" # grub safety reasons...
    ];
  };

  environment.etc = {
    "libvirt/vgabios/patched.rom".source = ./nvidia/GA102.patched.rom;
  };

  virtualisation.libvirtd = {
    enable = true;

    onBoot = "ignore";
    onShutdown = "shutdown";

    qemu.ovmf.enable = true;
    qemu.runAsRoot = true;
  };

  virtualisation.libvirtd.hooks.qemu = {
    single_gpu_passthrough = pkgs.writeShellScript "single_gpu_pt.sh" # bash
      ''
        #!/run/current-system/sw/bin/bash

        OBJECT=$1 # guest_name
        OPERATION=$2 # prepare|start|started|stopped|release|migrate|restore|reconnect|attach

        if [ "$OBJECT" != "win10" ]
        then
          exit 0
        fi

        set -x

        case $OPERATION in
          prepare)
            # Change to performance governor
            echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            
            # Isolate host to core 0
            systemctl set-property --runtime -- user.slice AllowedCPUs=0
            systemctl set-property --runtime -- system.slice AllowedCPUs=0
            systemctl set-property --runtime -- init.scope AllowedCPUs=0v
            
            # Logout
            loginctl terminate-user skarmux
            hyprctl dispatch exit
            sleep "1"
            
            # Unbind VTconsoles (TTY Sessions)
            echo 0 > /sys/class/vtconsole/vtcon0/bind
            echo 0 > /sys/class/vtconsole/vtcon1/bind
            sleep "1"
            
            # Unbind EFI Framebuffer
            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
            
            # Unload NVIDIA kernel modules
            # modprobe -r nvidia_uvm 
            modprobe -r nvidia_drm
            modprobe -r nvidia_modeset 
            modprobe -r nvidia
            modprobe -r i2c_nvidia_gpu
            modprobe -r drm_kms_helper
            modprobe -r drm
            
            # Detach GPU devices from host
            virsh nodedev-detach pci_0000_09_00_0
            virsh nodedev-detach pci_0000_09_00_1
            
            # Load vfio module
            modprobe vfio vfio_pci vfio_iommu_type1
            ;;

          release)
            reboot # TODO: fix kernel vtconsole rebind bug with patch

            exit
            
            # Unload vfio module
            modprobe -r vfio vfio_pci vfio_iommu_type1
            echo "$DATE vfio modules Unloaded" >> /home/skarmux/desktop/hook.log

            # Attach GPU devices from host
            virsh nodedev-reattach pci_0000_09_00_0
            virsh nodedev-reattach pci_0000_09_00_0 
            
            # Read nvidia x config
            # nvidia-xconfig --query-gpu-info > /dev/null 2>&1
            # echo "$DATE NVIDIA GPU XConfig Read!!" >> /home/skarmux/desktop/hook.log

            # Load NVIDIA kernel modules
            modprobe drm
            modprobe drm_kms_helper
            modprobe i2c_nvidia_gpu
            modprobe nvidia
            modprobe nvidia_modeset 
            modprobe nvidia_drm 
            # modprobe nvidia_uvm 
            sleep "5"
                      
            # Bind EFI Framebuffer
            echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind
            
            # Bind VTconsoles
            echo 1 > /sys/class/vtconsole/vtcon0/bind
            echo 1 > /sys/class/vtconsole/vtcon1/bind

            # Start display manager
            Hyprland

            # Return host to all cores
            systemctl set-property --runtime -- user.slice AllowedCPUs=0-3
            systemctl set-property --runtime -- system.slice AllowedCPUs=0-3
            systemctl set-property --runtime -- init.scope AllowedCPUs=0-3
            
            # Change to powersave governor
            echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            ;;
          *)
            exit 0
            ;;
        esac
      '';
  };

  # Add binaries to path so that hooks can use it
  systemd.services.libvirtd = {
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [ bash libvirt kmod systemd ripgrep sd ];
        };
      in
      [ env ];
  };

}
