{ pkgs, ... }:
{
  home.packages = with pkgs; [ keepassxc ];

  # TODO: I believe KeePassXC places the conf somewhere else.
  xdg.configFile."keepass/keepassxc.ini".source = ./keepassxc.ini;
}
