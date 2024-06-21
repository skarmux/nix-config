{ inputs, pkgs, config, ... }:
{
  imports = [
    inputs.feaston.nixosModules.default
    
    ./hardware-configuration.nix

    ../common/global
    ../common/users/skarmux

    (import ./service/firefox-sync.nix {
      inherit config;
      port = 8000; 
    })

    (import ./service/headscale.nix { 
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
  ];

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

    # hardware.argonone.enable = true; # TODO: Fan not spinning up... :(

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    feaston = {
      enable = true;
      domain = "feaston.skarmux.tech";
      port = 6000;
      enableNginx = true;
      enableTLS = true;
    };

    # Use this system as exit-node
    tailscale.useRoutingFeatures = "server";
    
    # TODO: Do I need this for resolving DNS?
    resolved.enable = true;
    
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;
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

}
