{ outputs, lib, config, pkgs, ... }:
let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at /persist
  hasPersistence = config.environment.persistence ? "/nix/persist";
in {
  services.openssh = {
    enable = true;

    # ports = [ 22 ];
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
      ChallengeResponseAuthentication = false;

      # Allow forwarding ports to everywhere
      # GatewayPorts = "clientspecified";
    };

    hostKeys = [
      {
        path = "${lib.optionalString hasPersistence "/nix/persist"}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    knownHosts = builtins.mapAttrs (name: cfg: {
      publicKeyFile = ../../${name}/ssh_host_ed25519_key.pub;
      # Alias for localhost if it's the same host
      extraHostNames = [] ++ (lib.optional (name == hostName) "localhost");
    }) hosts;
    
    knownHostsFiles = [
      (pkgs.writeText "github.keys" ''
        github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
        github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
        github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
      '')
    ];
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
