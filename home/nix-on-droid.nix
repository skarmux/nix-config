{ self, ... }:
{
  imports = [
    ./common/git
    ./common/helix
    ./common/shell
  ]
  ++ builtins.attrValues self.homeModules;
  
  home = {
    username = "nix-on-droid";
    homeDirectory = "/data/data/com.termux.nix/files/home";
    stateVersion = "24.11";
  };

  programs = {
    git.enable = true;
    helix = {
      enable = true;
      defaultEditor = true;
      file-picker = "tmux";
    };
  };

  systemd.user.startServices = "sd-switch";
}
