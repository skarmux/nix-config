{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ signal-desktop ];
    persistence."/nix/persist/home/skarmux" = {
      directories = [
        ".pki/nssdb"
        ".config/Signal"
      ];
    };
  };
}
