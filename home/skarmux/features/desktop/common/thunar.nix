{ pkgs, ... }: {
  # TODO: To let Thunar handle automatic mounting, one must launch thunar in daemon mode.

  home.packages = with pkgs; [
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman

    xarchiver

    gvfs # GNOME virtual file system
    sshfs # SSH

    # Thumbnails
    xfce.tumbler # Image
    libgsf # Open Document Format
    ffmpegthumbnailer # Video
    nufraw-thumbnailer # RAW
  ];

  # TODO: check if required
  # home.sessionVariables = {
  #    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
  # };

  xdg.desktopEntries.thunar = {
    name = "Thunar";
    genericName = "File Explorer";
    comment = "File Explorer";
    exec = "thunar %F";
    # https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html
    icon = "system-file-manager";
    mimeType = [ ];
    type = "Application";
    # https://specifications.freedesktop.org/menu-spec/latest/apa.html
    categories = [ "Utility" "FileManager" ];
  };
}
