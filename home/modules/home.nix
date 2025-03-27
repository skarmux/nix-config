{ pkgs, lib, username, ... }:
{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      home-manager # manage your own home environment
      direnv       # automatically execute .envrc
      bat          # cat replacement
      fzf          # fuzzy file finder
      jq           # json parsing
      p7zip        # 7z
      unzip        # zip
      unrar        # rar
    ];
    stateVersion = "24.11";
  };

  # Automatically restart systemd services on home-manager switch
  systemd.user.startServices = "sd-switch";
}
