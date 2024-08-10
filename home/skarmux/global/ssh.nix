{ lib, ... }:
{
  programs.ssh = {
    enable = true;
    # userKnownHostsFile = "~/.ssh/known_hosts";
  };
}
