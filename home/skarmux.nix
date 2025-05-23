{ inputs, self, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./common/ghostty.nix
    ./common/git
    # ./common/gpg.nix
    ./common/helix
    ./common/llm
    ./common/shell
    ./common/starship.nix
  ]
  ++ builtins.attrValues self.homeModules;
  
  home = {
    username = "skarmux";
    homeDirectory = "/home/skarmux";
    stateVersion = "24.11";
  };

  programs = {
    git.enable = true;
    helix = {
      enable = true;
      defaultEditor = true;
      file-picker = "tmux";
    };
    starship.enable = true;
  };

  catppuccin = {
    enable = true; # global
    flavor = "frappe";
    accent = "blue";
  };

  systemd.user.startServices = "sd-switch";

  sops = {
    age.keyFile = "/home/skarmux/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    validateSopsFiles = true;
  };
}
