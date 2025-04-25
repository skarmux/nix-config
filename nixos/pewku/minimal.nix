{ inputs, self, modulesPath, config, lib, pkgs, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  nixpkgs.hostPlatform.system = "aarch64-linux";

  networking = {
    networkmanager.enable = true;
    wireless.enable = false;
  };

  system.stateVersion = "24.11";

  # boot = {
  #   loader = {
  #     efi.canTouchEfiVariables = true;
  #     systemd-boot.enable = true;
  #     grub.enable = false;
  #     generic-extlinux-compatible.enable = false;
  #   };
  #   # exclude zfs to ba able to use the latest kernel
  #   supportedFilesystems = lib.mkForce [ "btrfs" "vfat" "cifs" "jfs" "f2fs" "xfs" ];
  #   kernelPackages = pkgs.linuxPackages_latest;
  # };

  environment.systemPackages = with pkgs; [
    disko
    git
    helix
    sops
    ssh-to-age
    age
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
    hostKeys = [{
      # NOTE: Copied from openssh module (2025-04-25)
      # Sops needs acess to the keys before the persist dirs are even mounted; so
      # just persisting the keys won't work, we must point at /persist
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  powerManagement.cpuFreqGovernor = "performance";

  users.users =
  {
    root.openssh.authorizedKeys = {
      keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOkPglvGlOsIUrTMQdL7DLPMXmDRzYF3wJzH/Ee2VU/dAAAABHNzaDo= skarmux@ignika"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBZmLgjKCWzv8nWieD5rQKpOBJnRXGZxqtXk9o5peHpZAAAABHNzaDo= skarmux@ignika"
      ];
    };
    nixos.openssh.authorizedKeys = {
      keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOkPglvGlOsIUrTMQdL7DLPMXmDRzYF3wJzH/Ee2VU/dAAAABHNzaDo= skarmux@ignika"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBZmLgjKCWzv8nWieD5rQKpOBJnRXGZxqtXk9o5peHpZAAAABHNzaDo= skarmux@ignika"
      ];
    };
  };
}
