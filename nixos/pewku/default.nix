{ inputs, pkgs, config, ... }:
{
  imports = [
    ./disk.nix
    ./hardware.nix
    ./services/nginx
    ./users/skarmux.nix

    # (import ./service/nix-serve.nix { 
    #   inherit config;
    #   port = 3337; 
    #   domain = "cache.skarmux.tech";
    # })

    # (import ./service/feaston.nix { 
    #   inherit inputs;
    #   port = 6000; 
    #   domain = "feaston.skarmux.tech";
    # })

    # (import ./service/homepage.nix { 
    #   inherit inputs;
    #   domain = "skarmux.tech";
    # })
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

    # Transfer logs to external syslog server
    # FIXME
    # rsyslogd.enable = true;

    # Use this system as exit-node
    tailscale.useRoutingFeatures = "server";
    
    # TODO: Do I need this for resolving DNS?
    #       And does it bite with Tailscale DNS?
    resolved.enable = true;
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
      # NOTE: This snippet from the deploy-rs example is required for the deployment activation
      # Another option would be to have the root user activated on the server
      extraRules = [{
        groups = [ "wheel" ];
        commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
      }];
    };
  };

  sops.defaultSopsFile = ./secrets.yaml;

  environment.persistence."/persist" = {
    directories = [ "/var/lib/acme" ];
  };
}
