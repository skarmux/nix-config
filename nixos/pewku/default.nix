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
      lazysql
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

    # postgres
    # postgresql = {
    #   enable = true;
    #   ensureDatabases = [ "sjc" ];
    #   enableTCPIP = true;
    #   # port = 5432;
    #   # database users can only access databases of the same name
    #   authentication = pkgs.lib.mkOverride 10 ''
    #     #type database  DBuser  auth-method   optional_ident_map
    #     local sameuser  all     peer          map=superuser_map
    #     # ipv4
    #     host  all       all     127.0.0.1/32  trust
    #     # ipv6
    #     host  all       all     ::1/128       trust
    #   '';
    #   identMap = ''
    #     # ArbitraryMapName systemUser DBUser
    #     superuser_map      root      postgres
    #     superuser_map      skarmux   postgres
    #     # Let other names login as themselves
    #     superuser_map      /^(.*)$   \1
    #   '';
    #   initialScript = pkgs.writeText "backend-initScript" ''
    #     CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
    #     CREATE DATABASE nixcloud;
    #     GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    #   '';
    # };
    # /postgres

    # Set an admin user: `sude paperless-manage createsuperuser`
    paperless = {
      enable = true;
      consumptionDirIsPublic = true;
      settings = {
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [
          ".DS_STORE/*"
          "desktop.ini"
        ];
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
        PAPERLESS_URL = "https://paperless.skarmux.tech";
      };
    };

    vikunja = {
      enable = true;
      port = 3456;
      frontendScheme = "http";
      frontendHostname = "projects.skarmux.tech";
    };

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
          enableACME = true;
        };
        "projects.skarmux.tech" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.vikunja.port}/";
            recommendedProxySettings = true;
          };
        };
        "paperless.skarmux.tech" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:28981/";
            recommendedProxySettings = true;
          };
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
      "cache-priv-key" = { };
    };
  };
}
