{ inputs, lib, config, outputs, ... }:
{
  imports = [
    inputs.hyprlock.homeManagerModules.hyprlock
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nixvim.homeManagerModules.nixvim
    inputs.sops-nix.homeManagerModules.sops
    inputs.impermanence.nixosModules.home-manager.impermanence
    ../features/cli
    ../features/helix
    ../features/neovim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs.overlays = builtins.attrValues outputs.overlays;
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  # TODO: Add explanation of `sd-switch`
  systemd.user.startServices = "sd-switch";

  sops = {
    # TODO: Enable OpenSSH service or something
    gnupg.home = "${config.home.homeDirectory}/.gnupg";
    defaultSopsFile = ../secrets.yaml;
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "skarmux";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = "24.05";
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
  };

  # Catppuccin colorscheme settings
  catppuccin.flavour = "mocha";
  catppuccin.accent = "mauve";

  xdg.userDirs = {
    enable = true;

    createDirectories = true;

    # Disable unwanted dirs
    desktop = null;
    publicShare = null;
    templates = null;

    extraConfig = {
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
    };
  };
}
