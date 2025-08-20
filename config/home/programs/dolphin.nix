{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.qtsvg
    kdePackages.kio-fuse # to mount remote filesystems via FUSE
    kdePackages.kio-extras # extra protocols support (sftp, fish and more)
    kdePackages.kio-admin # allows managing files as administrator
    kdePackages.baloo # extends tagging support
    # File previews
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers # image files, PDFs and Blender
    kdePackages.kdesdk-thumbnailers
    kdePackages.kimageformats
    kdePackages.taglib
  ];
} 