{ inputs, self, config, lib, pkgs, ... }:
{
  imports = [
    ./users
    ./disk.nix
    ./hardware.nix
    inputs.feaston.nixosModules.default
  ] ++ builtins.attrValues self.nixosModules;

  networking.hostName = "pewku";

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

  # programs.ssh = {
  #   knownHosts = [
  #     { publicKeyFile = ../ignika/ssh_host_ed25519_key.pub; }
  #   ];
  # };

  nix.settings.trusted-users = [ "skarmux" ];

  services = {

    feaston = {
      enable = true;
      enableTLS = false; # FIXME until acme works
      domain = "feaston.skarmux.tech";
      port = 6000; # internal
    };
    
    # Transfer logs to external syslog server
    # FIXME
    # rsyslogd.enable = true;
    
    # Use this system as exit-node
    # tailscale.useRoutingFeatures = "server";

    # TODO: Do I need this for resolving DNS?
    #       And does it bite with Tailscale DNS?
    # resolved.enable = true;

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
      virtualHosts."cache.skarmux.tech" = lib.mkIf config.services.nix-serve.enable {
        # forceSSL = true;
        # enableACME = true;
        locations."/" = {
          proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString 3337}";
          recommendedProxySettings = true;
        };
      };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  security = {
    # acme = {
    #   acceptTerms = true;
    #   defaults.email = "admin@skarmux.tech";
    # };
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
    };
  };
}
