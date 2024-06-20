{
  programs.ssh.enable = true;

  home.persistence."/nix/persist/home/skarmux" = {
    files = [".ssh/known_hosts"];
  };
}
