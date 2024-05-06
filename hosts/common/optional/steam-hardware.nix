{ pkgs, ... }: {
  # Enable udev rules for Steam hardware such as the Steam Controller, other supported controllers and the HTC Vive
  hardware.steam-hardware.enable = true;

  # environment.systemPackages = with pkgs; [ steam-run ];

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall =
  #     false; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall =
  #     true; # Open ports in the firewall for Source Dedicated Server
  #   gamescopeSession.enable = true;
  #   package = pkgs.steam.override {
  #     extraEnv = { MANGOHUD = true; };
  #     extraPkgs = pkgs: with pkgs; [ gamescope mangohud ];
  #   };
  # };
}
