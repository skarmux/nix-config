{ pkgs, ... }:
{
  programs.ghostty = {
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      font-size = 20;
      # FIXME: Ghostty crashes when images with alpha channels
      #        are being displayed with yazi
      # background-opacity = 0.8;
    };
  };
}
