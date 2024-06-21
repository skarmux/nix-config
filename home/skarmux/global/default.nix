{ inputs, outputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.sops-nix.homeManagerModules.sops
    inputs.nixvim.homeManagerModules.nixvim
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./zellij
    ./direnv.nix
    ./bash.nix
    ./nix.nix
    ./bat.nix
    ./eza.nix
    ./fish.nix
    ./yazi.nix
    ./git
    ./starship.nix
    ./btop.nix
    ./syncthing.nix
    ./ssh.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  programs = {
    home-manager.enable = true;
  };

  # Everything without a program.* option
  home.packages = with pkgs; [
    #vimv # replaced by yazi
    #tree # replaced by eza
    unzip
    fzf

    # Decoration
    cmatrix
    asciiquarium
    tty-clock

    du-dust # disk usage analyzer
    mprocs # TODO: zellij comparison 
    ripgrep
    speedtest-rs
    wiki-tui
    slides

    # Cross-platform Rust rewrite of the GNU coreutils
    uutils-coreutils
  ];

  # TODO: Add explanation of `sd-switch`
  systemd.user.startServices = "sd-switch";

  home = {
    username = lib.mkDefault "skarmux";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    persistence = {
      "/nix/persist/home/skarmux" = {
        directories = [
          "Downloads"
          "Documents"
          "Pictures"
          "Music"
          "Videos"
          "Projects"
          ".local/bin"
          ".local/share/nix"
        ];
        allowOther = true;
      };
    };
    stateVersion = "24.05";
  };

  # Catppuccin colorscheme settings
  catppuccin = {
    enable = true; # Apply to all available applications
    flavor = "mocha";
    accent = "mauve";
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;

    createDirectories = true;

    # Disable unwanted dirs
    #desktop = null;
    #publicShare = null;
    #templates = null;

    extraConfig = {
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
    };
  };
}
