{ inputs, self, pkgs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./common/alacritty.nix
    ./common/compression.nix
    ./common/direnv.nix
    ./common/eza.nix
    ./common/ghostty.nix
    ./common/git
    ./common/gpg.nix
    ./common/helix
    ./common/llm
    ./common/shell
    ./common/starship.nix
    ./common/tmux.nix
    ./common/wezterm.nix
    ./common/yazi.nix
    ./common/zathura.nix
    ./common/zellij
    ./common/zoxide.nix
  ]
  ++ builtins.attrValues self.homeModules;
  
  home = {
    username = "skarmux";
    homeDirectory = "/home/skarmux";
    stateVersion = "24.11";
    packages = with pkgs; [
      bat # cat replacement
      fzf # fuzzy file finder
      jq  # json parsing


    ];
  };

  programs = {
    bash.enable = true;
    btop.enable = true;
    eza.enable = true;
    git.enable = true;
    helix = {
      enable = true;
      defaultEditor = true;
      file-picker = "tmux";
    };
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
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
