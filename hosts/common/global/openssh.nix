{ outputs, lib, config, ... }:
let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at /persist
  hasOptinPersistence = config.environment.persistence ? "/nix/persist";
in {
  services.openssh = {
    enable = true;

    ports = [ 22 ];
    allowSFTP = false;
    
    settings = {
      Compression = "yes";

      X11Forwarding = false;

      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";

      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";

      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };

    hostKeys = [
      {
        path = "${lib.optionalString hasOptinPersistence "/nix/persist"}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    knownHosts = builtins.mapAttrs (name: cfg: {
      publicKeyFile = ../../${name}/ssh_host_ed25519_key.pub;
      extraHostNames = 
        []
        ++
        # Alias for localhost if it's the same host
        (lib.optional (name == hostName) "localhost");
      })
      hosts;
  };

  # Implement a simple fail2ban service for sshd
  # as brute force protection
  # services.sshguard.enable = true;

  # Add terminfo for SSH from popular terminal emulators
  environment.enableAllTerminfo = true;

  # Passwordless sudo when SSH'ing with keys
  security.pam.sshAgentAuth = {
    enable = true;
    authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
  };

}
