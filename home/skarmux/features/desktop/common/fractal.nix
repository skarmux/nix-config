{ pkgs, ... }: {
  home.packages = with pkgs; [ fractal ];

  xdg.desktopEntries.fractal = {
    name = "Fractal";
    genericName = "Messenger";
    comment = "Messenger";
    exec = "fractal";
    # https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html
    icon = "system-file-manager";
    mimeType = [ ];
    type = "Application";
    # https://specifications.freedesktop.org/menu-spec/latest/apa.html
    categories = [ "Utility" ];
  };
}
