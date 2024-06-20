{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  nix.settings = {
    substituters = [
        "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  environment.sessionVariables = {
    XDG_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    _JAVA_AWT_WM_NONREPARENTING = "1";

    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    LIBSEAT_BACKEND = "logind";
  };
}
