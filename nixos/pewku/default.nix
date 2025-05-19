{ inputs, self, config, pkgs, ... }:
{
  imports = [
    ./users
    ./disk.nix
    ./hardware.nix
    ../common/sops.nix
    ../common/openssh.nix
    ../common/nix.nix
    ../common/locale.nix
    inputs.impermanence.nixosModules.impermanence
    inputs.feaston.nixosModules.default
    inputs.homepage.nixosModules.default
  ] ++ builtins.attrValues self.nixosModules;

  system.stateVersion = "24.11";

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      grub.enable = false;
      generic-extlinux-compatible.enable = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  programs.fuse.userAllowOther = true;

  environment = {
    systemPackages = with pkgs; [
      helix
      rsync
      htop
      dust
    ];
    persistence."/persist" = {
      directories = [
        # Store all logs
        "/var/log"
        # Let's Encrypt: ACME keys after successful challenge-response
        "/var/lib/acme"
        # User configuration, etc.
        "/var/lib/nixos"
        # System crash dumps for analysis
        "/var/lib/systemd/coredump"
        # Event store database
        "/var/lib/feaston"
      ];
      files = [
        # FIXME bind-mount fails on startup
        # https://discourse.nixos.org/t/impermanence-a-file-already-exists-at-etc-machine-id/20267
        # "/etc/machine-id"
      ];
    };
  };

  nix.settings.trusted-users = [ "skarmux" ];

  services = {

    # anubis = {
    #   defaultOptions = {
    #     enable = true;
    #   };
    #   instances = {
    #     "feaston" = {
    #     };
    #   };
    # };

    feaston = {
      enable = true;
      enableTLS = true;
      domain = "feaston.skarmux.tech";
      port = 6000;
    };

    homepage = {
      enable = true;
      domain = "skarmux.tech";
    };
    
    # Transfer logs to external syslog server
    # FIXME
    # rsyslogd.enable = true;
    
    # Use this system as exit-node
    # tailscale.useRoutingFeatures = "server";

    # TODO: Do I need this for resolving DNS?
    #       And does it bite with Tailscale DNS?
    resolved.enable = true;

    openssh = {
      enable = true;
      settings.AllowUsers = [ "skarmux" ];
    };

    nix-serve = {
      enable = true;
      secretKeyFile = config.sops.secrets."cache-priv-key".path;
      port = 3337;
    };

    nginx = {
      enable = true;
      
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "skarmux.tech" = {
          # forceSSL: Redirect HTTP to HTTPS; onlySSL: ignore HTTP entirely
          forceSSL = true;
          sslCertificate = ./ssl/skarmux_tech/ssl-bundle.crt;
          sslTrustedCertificate = ./ssl/skarmux_tech/SectigoRSADomainValidationSecureServerCA.crt;
          sslCertificateKey = config.sops.secrets."skarmux_tech/certificate_key".path;
        };
        # "cache.skarmux.tech" = {
          # forceSSL = true;
          # enableACME = true;
        #   locations."/" = {
        #     proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString 3337}";
        #     recommendedProxySettings = true;
        #   };
        # };
      };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  networking = {
    hostName = "pewku";
    wireless.enable = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "admin@skarmux.tech";
    };
    auditd.enable = true;
    audit = {
      enable = true;
      rules = [ "-a exit,always -F arch=b64 -S execve" ];
    };
    sudo = {
      # Only allow sudo binary execution for members of the wheel group
      execWheelOnly = true;

      # Passwordless-Sudo
      # NOTE: This snippet from the deploy-rs example is required for the deployment activation
      #       Another option would be to have the root user activated on the server
      extraRules = [{
        groups = [ "wheel" ];
        commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
      }];
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "cache-priv-key" = {};
      "skarmux_tech/certificate_key" = {
        owner = "nginx";
      };
    };
  };
}
