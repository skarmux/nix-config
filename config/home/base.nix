{ pkgs, ... }:
{  
  imports = [
    ./programs/git
    ./programs/helix
    ./programs/shell
    ./programs/starship.nix
    ./services/syncthing.nix
  ];

  home.packages = with pkgs; [
    timewarrior
    taskwarrior3
    taskwarrior-tui
    btop
  ];

  programs = {
    helix = {
      defaultEditor = true;
      file-picker = "tmux";
    };
  };

  systemd.user.startServices = "sd-switch";
}