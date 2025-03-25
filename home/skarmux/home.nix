{ inputs, self, pkgs, lib, config, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.sops-nix.homeManagerModules.sops
    inputs.impermanence.homeManagerModules.impermanence
  ];

  home = {
    username = "skarmux";
    homeDirectory = "/home/skarmux";
    stateVersion = "24.11";
    packages = with pkgs; [
      git   # versioning
      bat   # cat replacement
      fzf   # fuzzy file finder
      jq    # json parsing
      grc   # semantic coloring of stdout for non-themed output
      p7zip # 7z
      unzip # zip
      unrar # rar
    ];
  };

  # Automatically restart systemd services on home-manager switch
  systemd.user.startServices = "sd-switch";
}
