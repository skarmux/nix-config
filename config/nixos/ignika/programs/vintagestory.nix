{ pkgs, lib, ... }:
{
    nixpkgs = {
        # TODO: Move to an `overlays` directory
        overlays = [
            (final: prev: {
                vintagestory = prev.vintagestory.overrideAttrs ( oldAttrs: rec {
                    version = "1.20.11";
                    src = pkgs.fetchurl {
                    url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
                    hash = "sha256-IOreg6j/jLhOK8jm2AgSnYQrql5R6QxsshvPs8OUcQA=";
                    };
                });
            })
        ];
    };

    environment.systemPackages = with pkgs; [
        vintagestory
    ];
}