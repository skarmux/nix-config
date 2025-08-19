{
    imports = [
        ./steam.nix
        ./vintagestory.nix
        ./minecraft.nix
    ];

    programs = {
        openvpn3.enable = true; # hackthebox
        kdeconnect.enable = true;
        fish.enable = true;
    };
}