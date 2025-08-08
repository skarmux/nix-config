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
let
  passthrough_vm_names = [
    "win10"    
  ];

  vfio_modules = [
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
  ];

  # Complete list. Not all of them are expected
  # to be active on the host system.
  nvidia_modules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
    "nvidia_uvm"
    "i2c_nvidia_gpu"
    "drm_kms_helper"
    "drm"
  ];

  # IOMMU Group 17
  # 02:08.0 PCI Bridge (DO NOT USE FOR VM!)
  # 06:00.0 Non Essential
  # 06:00.1 USB Controller [1022:149c]
  # 06:00.3 USB Controller [1022:149c]

  # IOMMU Group 21
  # 04:00.0 Intel WiFi
  
  # IOMMU Group 23
  # 09:00.0 VGA [0300] [10de:2204] <--
  iommu_nvidia_vga = "pci_0000_09_00_0";
  # 09:00.1 AUDIO [0403] [10de:1aef] <--
  iommu_nvidia_audio = "pci_0000_09_00_1";

  # IOMMU Group 27
  # 0b:00.3 USB Controller [1022:149c]

  # IOMMU Group 28
  # 0b:00.4 HD Audio [1022:1487]

  # AMD CPU : IOMMU, NX MODE, SVM MODE

  single_gpu_passthrough = pkgs.writeShellApplication {
    name = "single_gpu_pt";
    runtimeInputs = [
      # TODO: I wanna be host session agnostic here.
      config.programs.hyprland.package # Hyprland, hyprctl
    ];
    text = ''
      vm_name=$1
      action=$2 # prepare | start | started | stopped | release | migrate | restore | reconnect | attach

      # Ensure this script is executed only with selected virtual machines
      case "$vm_name" in
        ${lib.concatStringsSep " | " (builtins.map (mod: "\"${mod}\"") passthrough_vm_names)})
          exit 0
          ;;
        *)
          ;;
      esac

      declare -a vfio_modules=(${lib.concatStringsSep ", " (builtins.map (mod: "\"${mod}\"") vfio_modules)})

      case "$action" in
        "prepare")
          # Logout (close display session)
          # TODO: Suspend/Resume wayland session would be perfect here~
          loginctl terminate-user ${config.users.users.skarmux.name}
          hyprctl dispatch exit # TODO: necessary after `terminate-user`?
          sleep 1
          
          # Change to performance governor
          # TODO: Keep host session active and control performance profile with opt-in
          #       `gamemode` toggle instead.
          # echo "performance" > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
          
          # Isolate host processes to single cpu core 0
          systemctl set-property --runtime -- user.slice AllowedCPUs=0
          systemctl set-property --runtime -- system.slice AllowedCPUs=0
          systemctl set-property --runtime -- init.scope AllowedCPUs=0
          
          # Unbind VTconsoles (TTY Sessions)
          for f in /sys/class/vtconsole/vtcon[0-1]/bind; do echo 0 > "$f"; done
          sleep 1
          
          # Unbind EFI Framebuffer
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
          
          # Unload NVIDIA kernel modules
          declare -a nvidia_modules=(${lib.concatStringsSep ", " (builtins.map (mod: "\"${mod}\"") nvidia_modules)})
          rm /tmp/single_gpu_pt_unloaded_nvidia_modules
          for module in "''${nvidia_modules[@]}"; do
            modprobe --verbose --remove "$module"
            # NOTE: `nvidia_uvm` might or might not be in use, depending on driver configuration on
            #       the host. Therefore I used this solution to keep track of modules that are in
            #       use by the host.
            if [ $? -eq 0 ]; then
              echo "$module" >> /tmp/single_gpu_pt_unloaded_nvidia_modules
            fi
          done
          
          # Detach GPU devices from host
          virsh nodedev-detach ${iommu_nvidia_vga}
          virsh nodedev-detach ${iommu_nvidia_audio}
          
          # Load vfio modules
          for module in "''${vfio_modules[@]}"; do
            modprobe --verbose "$module"
          done
          ;;

        "release")
          # Unload vfio modules
          # echo "$DATE vfio modules Unloaded" >> ${config.users.users.skarmux.home}/desktop/hook.log
          for module in "''${vfio_modules[@]}"; do
            modprobe --verbose --remove "$module"
          done

          # Attach GPU devices from host
          virsh nodedev-reattach ${iommu_nvidia_vga}
          virsh nodedev-reattach ${iommu_nvidia_audio}
          
          # Load NVIDIA kernel modules (in reverse order as they have been unloaded)
          while read module; do
            modprobe --verbose "$module"
          done < /tmp/single_gpu_pt_unloaded_nvidia_modules
          rm /tmp/single_gpu_pt_unloaded_nvidia_modules
          sleep 5
                    
          # Bind EFI Framebuffer
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind
          
          # Bind VTconsoles
          # FIXME: fix kernel vtconsole rebind bug with patch
          for f in /sys/class/vtconsole/vtcon[0-1]/bind; do echo 1 > "$f"; done

          # Return host to all cores
          cores_total=$(( $(nproc) - 1 )) # `-1` to get highest index
          systemctl set-property --runtime -- user.slice AllowedCPUs="0-$cores_total"
          systemctl set-property --runtime -- system.slice AllowedCPUs="0-$cores_total"
          systemctl set-property --runtime -- init.scope AllowedCPUs="0-$cores_total"
          
          # Change back to host governor setting
          # echo "${config.powerManagement.cpuFreqGovernor}" > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

          # Start display manager
          # TODO: Start display session from displayManager config
          Hyprland
          ;;
        *)
          exit 0
          ;;
      esac
    '';
  };
in
{
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
      "iommu=pt" # grub safety reasons... FIXME: I'm now using systemd boot
    ];
  };

  assertions = let
    modules = config.boot.initrd.kernelModules;
    # Helper to find all indices of matching modules
    findIndices = pred: list:
      lib.lists.foldl (acc: elem: let i = acc.index; xs = acc.indices; in {
        index = i + 1;
        indices = if pred elem then xs ++ [i] else xs;
      }) { index = 0; indices = []; } list;
    vfioIndices = (findIndices (m: builtins.elem m vfio_modules) modules).indices;
    nvidiaIndices = (findIndices (m: builtins.elem m nvidia_modules) modules).indices;
  in [
    {
      assertion = builtins.all (vfioIndex:
          builtins.all (nvidiaIndex: vfioIndex < nvidiaIndex) nvidiaIndices
        ) vfioIndices;
      message = ''
        vfio kernel modules must be ordered before nvidia/drm kernel modules.
        Current order: ${toString modules}
      '';
    }
  ];

  environment = {
    etc = {
      # TODO: Add documentation on why I patched the rom and how I did it.
      "libvirt/vgabios/patched.rom".source = ../hardware/nvidia/GA102.patched.rom;
    };
  };

  programs.virt-manager.enable = true;

  users = {
    users.skarmux.extraGroups = [ "libvirtd" ];
    groups.libvirtd.members = [ "skarmux" ];
  };

  virtualisation.libvirtd = {
    enable = true;

    onBoot = "ignore";
    onShutdown = "shutdown";

    # spiceUSBRedirection.enable = true;

    qemu.ovmf.enable = true;
    qemu.runAsRoot = true;

    hooks.qemu = {
      inherit single_gpu_passthrough;
    };
  };

  home-manager.users.skarmux = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  # Add binaries to path so that hooks can use it
  systemd.services.libvirtd.path = [
    (pkgs.buildEnv {
      name = "qemu-hook-env";
      paths = with pkgs; [
        bash
        libvirt
        kmod
        systemd
        ripgrep
        sd
      ];
    })
  ];

}
