{ pkgs, ... }: {
  home.packages = with pkgs; [ keepassxc ];

  xdg.configFile."keepass/keepassxc.ini".source = ./keepassxc.ini;
}
