{pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      plex-media-player
      plexamp
    ];
    # persistence."/nix/persist/home/skarmux" = {
    #   directories = ["Library"];
    # };
  };
}
