{ pkgs, self, ... }:
{
  users.defaultUserShell = pkgs.bash;
}
