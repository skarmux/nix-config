{ pkgs, lib, ... }:
{  
  imports = [
    ./programs/git
    ./programs/helix
    ./programs/shell
    ./programs/starship.nix
  ];

  home.packages = with pkgs; [
    # timewarrior
    # taskwarrior3
    # taskwarrior-tui
    btop
  ];

  home = {
    username = lib.mkDefault "skarmux";
    stateVersion = "25.05";
  };

  programs = {
    helix = {
      defaultEditor = true;
      file-picker = "tmux";
    };
  };

  systemd.user.startServices = "sd-switch";
}