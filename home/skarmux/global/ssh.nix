{
  programs.ssh = {
    enable = true;
    userKnownHostsFile = "~/.ssh/known_hosts";
  };

  # home.persistence."/nix/persist/home/skarmux" = {
  #   files = [".ssh/known_hosts"];
  # };
}
