{ config, ... }:
{
  programs.wezterm = {
    enable = true;
    # extraConfig = /* lua */ ''
    # return {
    #   font = ${config.fontProfiles.regular.family},
    #   font_size = 14.0
    # }
    # '';
  };
}
