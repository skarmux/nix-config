{ pkgs, lib, ... }:
{  
  imports = [
    ./programs/git
    ./programs/helix
    ./programs/shell
    ./programs/starship.nix
  ];

  home.packages = with pkgs; [
    btop
    unixtools.column
    unixtools.xxd
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
    fish.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}