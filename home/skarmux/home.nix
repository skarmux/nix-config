{ inputs, self, pkgs, lib, config, ... }:
{
  imports = [
    ./alacritty.nix
    ./direnv.nix
    ./eza.nix
    ./ghostty.nix
    ./git
    ./gpg.nix
    ./helix
    ./shell
    ./starship.nix
    ./tmux.nix
    ./wezterm.nix
    ./yazi.nix
    ./zathura.nix
    ./zellij
    ./zoxide.nix
  ]
  ++ builtins.attrValues self.homeModules
  ++ [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  
  home = {
    username = "skarmux";
    homeDirectory = "/home/skarmux";
    stateVersion = "24.11";
    packages = [
      pkgs.bat # cat replacement
      pkgs.fzf # fuzzy file finder
      pkgs.jq  # json parsing
      pkgs.grc # auto coloring of stdout
    ];
    file = {
      ".ssh/id_yc.pub".source = ./id_yc.pub;
      ".ssh/id_ya.pub".source = ./id_ya.pub;
    };
  };

  programs = {
    bash.enable = true;
    btop.enable = true;
    eza.enable = true;
    git.enable = true;
    helix = { enable = true; defaultEditor = true; };
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
  };

  compression.enable = true;

  catppuccin = {
    enable = true; # global
    flavor = "mocha";
    accent = "mauve";
  };

  systemd.user.startServices = "sd-switch";

  sops = {
    # FIXME
    age.keyFile = "/home/skarmux/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    validateSopsFiles = false;
    # gnupg.home = config.programs.gpg.homedir;
    secrets = {
      "ssh/yc".path = "/home/skarmux/.ssh/id_yc";
      "ssh/ya".path = "/home/skarmux/.ssh/id_ya";
    };
  };
}
