{ inputs, pkgs, config, ... }:
{
  imports = [

    # TODO: Keep nginx hosted services available whilst
    #       running the wireguard vpn
    # (import ../common/optional/deluge.nix {
    #   inherit config;
    #   port = 8112;
    # })

    (import ./service/headscale { 
      inherit config;
      port = 8085; 
      portForMetrics = 8095; 
      domain = "tailscale.skarmux.tech";
    })

    (import ./service/nix-serve.nix { 
      inherit config;
      port = 3337; 
      domain = "cache.skarmux.tech";
    })

    (import ./service/feaston.nix { 
      inherit inputs;
      port = 6000; 
      domain = "feaston.skarmux.tech";
    })

    (import ./service/homepage.nix { 
      inherit inputs;
      domain = "skarmux.tech";
    })

    ./hardware.nix
  ];

  sops.secrets = {
    "skarmux_tech/certificate_key" = {
      owner = "nginx";
      sopsFile = ./secrets.yaml; 
    };
  };

  # To keep the syncthing user service active 24/7
  # NOTE: This is a small security risk!
  users.users.skarmux.linger = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      grub.enable = false;
      generic-extlinux-compatible.enable = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services = {

    # Transfer logs to external syslog server
    rsyslogd.enable = true;

    # Secure Messenger Network Node
    # tox-node.enable = true;

    # Use this system as exit-node
    tailscale.useRoutingFeatures = "server";
    
    # TODO: Do I need this for resolving DNS?
    #       And does it bite with Tailscale DNS?
    resolved.enable = true;
    
    nginx = {
      enable = true;

      # TODO: How does this play with headscale?
      # tailscaleAuth = { enable = true; };

      # recommendedTlsSettings = true;
      # recommendedZstdSettings = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;

      # TODO: Setup nas as syslog server
      # appendConfig = ''
      #   error_log syslog:server=whenua;
      #   access_log syslog:server=whenua;
      # '';
    };

  };

  powerManagement.cpuFreqGovernor = "ondemand";

  networking = {
    hostName = "pewku";
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
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };

    sudo = {
      execWheelOnly = true;

      # NOTE: This snippet from the deploy-rs example is required for the deployment activation
      # Another option would be root on the server
      extraRules = [{
        groups = [ "wheel" ];
        commands = [{
          command = "ALL";
          options = [ "NOPASSWD" ];
        }];
      }];
    };
  };

  environment.persistence."/persist" = {
    directories = [ "/var/lib/acme" ];
  };
}
