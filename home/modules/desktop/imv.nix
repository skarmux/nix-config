{
  programs.imv = {
    enable = true;
  };

  xdg.mimeApps = {
    defaultApplications = {
      "image/jpeg" = [ "imv.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/apng" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
    };
  };
}
