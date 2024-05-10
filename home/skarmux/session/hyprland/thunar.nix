{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman

    xarchiver

    # Thumbnails
    xfce.tumbler # Image
    libgsf # Open Document Format
    ffmpegthumbnailer # Video
    nufraw-thumbnailer # RAW
  ];

  xdg.desktopEntries.thunar = {
    name = "Thunar";
    genericName = "File Explorer";
    comment = "File Explorer";
    exec = "thunar %F";
    icon = "system-file-manager";
    mimeType = [ ];
    type = "Application";
    categories = [ "Utility" "FileManager" ];
  };
}
