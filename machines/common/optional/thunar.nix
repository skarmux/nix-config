{ pkgs, ... }:
{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;

  # Mount, trash, and other functionalities
  services.gvfs = {
    enable = true;
  };

  # Thumbnails support
  services.tumbler.enable = true;
}
