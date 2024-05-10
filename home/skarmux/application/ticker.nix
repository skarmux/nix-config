{ pkgs, config, ... }:
{
  home.packages = with pkgs; [ ticker ];

  sops.secrets."ticker" = {
    sopsFile = ../secrets.yaml;
    path = "${config.home.homeDirectory}/.config/.ticker.yaml";
  };
}
