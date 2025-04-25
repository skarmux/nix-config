{ inputs, self, pkgs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.impermanence.homeManagerModules.impermanence
    ./alacritty.nix
    ./direnv.nix
    ./eza.nix
    ./ghostty.nix
    ./git
    ./gpg.nix
    ./helix
    ./llm
    ./shell
    ./starship.nix
    ./tmux.nix
    ./wezterm.nix
    ./yazi.nix
    ./zathura.nix
    ./zellij
    ./zoxide.nix
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
      grc # auto coloring of stdout
    ];
    file = {
      ".ssh/id_yc.pub".source = ../../keys/id_yc.pub;
      ".ssh/id_ya.pub".source = ../../keys/id_ya.pub;
    };
    persistence."/persist/home/skarmux" = {
      directories = [
        ".ssh"
      ];
      files = [
        ".config/sops/age/keys.txt"
      ];
      allowOther = true;
    };
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

  compression.enable = true;

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
    secrets = {
      "ssh/yc".path = "/home/skarmux/.ssh/id_yc";
      "ssh/ya".path = "/home/skarmux/.ssh/id_ya";
    };
  };
}
