{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix
    ../common/global/locale.nix
  ];

  users = {
    mutableUsers = false;
    users = {
      skarmux = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialPassword = "monster6";
        openssh.authorizedKeys.keyFiles = [
          ../../home/skarmux/yubikey/id_ed25519.pub
          ../../home/skarmux/yubikey/id_ecdsa_sk.pub
        ];
      };
    };
  };

  services = {
    # Enable fan controller from Argon One Case
    hardware.argonone.enable = true;
    openssh = {
      enable = true;
      allowSFTP = false;
      settings = {
        Compression = "yes";
        AllowTcpForwarding = "yes";
        AllowAgentForwarding = "no";
        AllowStreamLocalForwarding = "no";
        AuthenticationMethods = "publickey";
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = "yes";
        AllowUsers = [ "skarmux" ];
      };
    };
    tailscale.enable = true;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";

  # Only users of wheels group can use nix package manager daemon
  nix.settings.allowed-users = [ "@wheel" ];

  powerManagement.cpuFreqGovernor = "ondemand";

  networking = {
    hostName = "pewku";
    wireless.enable = false;
    firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      # allowedTCPPorts = [ 80 443 ];
    };
  };

  security = {
    sudo.execWheelOnly = true;
    auditd.enable = true;
    # Use `journalctl -f` to see audit logs
    audit = {
      enable = true;
      rules = [
        # Log every time a program is attempted to be run.
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
  };

  environment = {
    # Prevent default packages from being installed
    systemPackages = lib.mkForce [ pkgs.bash ];

    etc = {
      "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
      "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
      "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
      "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
      "machine-id".source = "/nix/persist/etc/machine-id";
    };

    persistence."/nix/persist" = {
      directories = [
        "/var/lib"
        "/var/log"
        "/etc/nixos"
        "/srv"
      ];
    };
  };

  fileSystems = {
    "/var/lib".options = [ "noexec" ];
    "/var/log".options = [ "noexec" ];
    "/etc/nixos".options = [ "noexec" ];
    "/srv".options = [ "noexec" ];
  };

  system.stateVersion = "24.05";
}
