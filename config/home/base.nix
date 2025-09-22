{ pkgs, lib, ... }:
{  
  imports = [
    ./programs/git
    ./programs/helix
    ./programs/shell
    ./programs/starship.nix
    ./programs/superfile
  ];

  home.packages = with pkgs; [
    btop
    unixtools.column
    unixtools.xxd
    parallel
    shellcheck
  ];

  home = {
    username = lib.mkDefault "skarmux";
    stateVersion = "25.05";
  };

  programs = {
    helix = {
      defaultEditor = true;
      # file-picker = "zellij";
    };
    fish.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}