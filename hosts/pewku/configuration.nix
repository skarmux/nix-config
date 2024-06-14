{ inputs, pkgs, config, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../common/global/locale.nix
    ../common/global/sops.nix
    ./hardware-configuration.nix

    ./services/feaston.nix
    ./services/panamax.nix
    ./services/syncstorage.nix
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

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      grub.enable = false;
      generic-extlinux-compatible.enable = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # From NGINX performance optimization guide
  # sudo sysctl -w net.core.somaxconn=4096

  sops.secrets."skarmux_tech/certificate_key" = {
    owner = "nginx";
    sopsFile = ./secrets.yaml; 
  };

  services = {
    # Enable fan controller from Argon One Case
    # TODO: Fan not spinning up... :(
    # hardware.argonone.enable = true;
    nginx = {
      enable = true;

      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;
      
      virtualHosts = {
        "skarmux.tech" = {
          onlySSL = true; # TODO: Is 'forceSSL' better?
          sslCertificate = ./nginx/ssl/skarmux_tech/ssl-bundle.crt;
          sslTrustedCertificate = ./nginx/ssl/skarmux_tech/SectigoRSADomainValidationSecureServerCA.crt;
          sslCertificateKey = config.sops.secrets."skarmux_tech/certificate_key".path;
          locations."/" = {
            # TODO: My personal landing page. :3
            return =404;
          };
        };
      };
    };
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
    # tailscale.enable = true;
    # resolved.enable = true;
  };

  # Only users of wheels group can use nix package manager daemon
  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      experimental-features = "nix-command flakes";
      trusted-users = [ "skarmux" "nix-ssh" ];
      require-sigs = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  networking = {
    hostName = "pewku";
    wireless.enable = false;
    firewall = {
      enable = true;
      # trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedTCPPorts = [ 80 443 ];
    };
  };

  security = {
    sudo = {
      # TODO: Check if feaston can start user service with this one set to 'true'
      execWheelOnly = false;
    };
    # auditd.enable = true;
    # Use `journalctl -f` to see audit logs
    # audit = {
    #   enable = true;
    #   rules = [
    #     # Log every time a program is attempted to be run.
    #     "-a exit,always -F arch=b64 -S execve"
    #   ];
    # };
  };

  # NOTE: This snippet from the deploy-rs example is required for the deployment activation
  # Another option would be root on the server
  security.sudo.extraRules = [{
    groups = [ "wheel" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  environment = {
    # Prevent default packages from being installed
    # systemPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [ git vim ];

    # etc = {
    #   "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
    #   "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
    #   "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
    #   "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
    #   "machine-id".source = "/nix/persist/etc/machine-id";
    # };

    # persistence."/nix/persist" = {
    #   directories = [
    #     "/var/lib"
    #     "/var/log"
    #     "/etc/nixos"
    #     "/srv"
    #   ];
    # };
  };


  system.stateVersion = "24.05";
}
