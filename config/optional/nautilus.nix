{ pkgs, ... }:
{
  # Configuration backend for GNOME applications
  programs = {
    dconf.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };
  };

  environment = {
    sessionVariables = {
      # Fixes certain desktop apps like nautilus to freeze on close
      # https://github.com/NixOS/nixpkgs/issues/353990#issuecomment-2551404760
      GSK_RENDERER = "ngl";
    };
    systemPackages = with pkgs; [
      nautilus
      adwaita-icon-theme # default icon theme
      gnome-themes-extra
    ];
  };

  nixpkgs.overlays = [
    (self: super: {
      gnome = super.gnome.overrideScope (gself: gsuper: {
        # gvfs = pkgs.gvfs.override { gnomeSupport = true; };
        # Add GStreamer plugin to nautilus
        nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
          buildInputs = nsuper.buildInputs ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
        });
      });
    })
  ];

  # Access network shares
  services = {
    gvfs.enable = true; # Filesystem
    gnome.gnome-keyring.enable = true; # Credentials
  };
}
