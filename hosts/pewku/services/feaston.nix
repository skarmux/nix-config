{ inputs, pkgs, ... }: {
  users.users.feaston = {
    description = "Feaston daemon user";
    isNormalUser = true;
    password = "";
    group = "feaston";

    # Whether to enable lingering for this user. If true, systemd user units
    # will start at boot, rather than starting at login and stopping at logout.
    # This is the declarative equivalent of running loginctl enable-linger for 
    # this user.
    linger = true;

    openssh.authorizedKeys.keys =
      [ (builtins.readFile ../../../home/skarmux/id_ed25519.pub) ];
  };

  users.groups."feaston" = { };

  home-manager.users.feaston = {
    home.stateVersion = "24.05";
    systemd.user.services."feaston" = {

      Install.WantedBy = [ "multi-user.target" ];
      # path = inputs.feaston.packages.${pkgs.system}.default; 
      # script = "feaston";
    };
  };
}
