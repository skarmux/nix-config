{ pkgs, ... }:
{
  home.packages = with pkgs; [
    superfile
  ];

  home.file.".config/superfile/config.toml".source = ./config.toml;
  home.file.".config/superfile/hotkeys.toml".source = ./hotkeys.toml;
}