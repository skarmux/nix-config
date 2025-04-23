{ inputs, self, pkgs, config, ... }:
{
  imports = [
    ./disk.nix
    ./hardware.nix
    ./users/skarmux.nix
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

  services = {
    feaston = {
      enable = true;
      enableTLS = true;
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
    resolved.enable = true;

    openssh = {
      enable = true;
      settings.AllowUsers = [ "skarmux" ];
    };

    nginx = {
      enable = true;
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
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

  sops.defaultSopsFile = ./secrets.yaml;

  # environment.persistence."/persist" = {
  #   directories = [ "/var/lib/acme" ];
  # };
}
