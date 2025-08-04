{ pkgs, ... }:
{
  imports = [
    ./services
    ./hardware
    ./users
  ];

  system.stateVersion = "25.05";

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      grub.enable = false;
      generic-extlinux-compatible.enable = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  programs = {
    fuse.userAllowOther = true;
    yubikey-touch-detector.enable = false;
  };

  environment = {
    systemPackages = with pkgs; [
      helix
      rsync
      btop
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
    };
  };

  nix.settings.trusted-users = [ "skarmux" ];

  services = {

    # Transfer logs to external syslog server
    # FIXME
    # rsyslogd.enable = true;

    # Use this system as exit-node
    # tailscale.useRoutingFeatures = "server";

    # TODO: Do I need this for resolving DNS?
    #       And does it bite with Tailscale DNS?
    resolved.enable = true;

    nginx = {
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
    };
  };

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
      # Only allow sudo binary execution (*sudo: members of the wheel group)
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
}
