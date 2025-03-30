{ inputs, self, pkgs, lib, config, ... }:
{
  imports = [
    ./alacritty.nix
    ./direnv.nix
    ./eza.nix
    ./gpg.nix
    ./git
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
    inputs.sops-nix.homeManagerModules.sops
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  
  home = {
    username = "skarmux";
    homeDirectory = "/home/skarmux";
    packages = [
      pkgs.bat # cat replacement
      pkgs.fzf # fuzzy file finder
      pkgs.jq  # json parsing
      pkgs.grc # auto coloring of stdout
    ];
    file = {
      ".ssh/id_ed25519.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOHnEYhX+q+xTVjoIIAjT+tn1NVAtqLjkE8J88YS14w skarmux";
      ".ssh/id_ecdsa_sk.pub".text = "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCtxwv03fCfq44djR+y38BEyrKnJAUWN+X8kXkhXNrk87pViOBbRuZ95F4uySg48PEgYRG2jFGQ4Ho8BJTVSYIAAAAAEc3NoOg== skarmux@teridax";
    };
    stateVersion = "24.11";
  };

  programs = {
    bash.enable = true;
    btop.enable = true;
    direnv.enable = true;
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
    defaultSopsFile = ./secrets.yaml;
    # - skarmux profile: No key source configured for sops.
    # Either set
    # - services.openssh.enable (preferrable?)
    # - sops.age.keyFile
    # - sops.gnupg.home
    # - sops.gnupg.qubes-split-gpg.enable
    gnupg.home = config.programs.gpg.homedir;
    secrets = {
      "ssh/id_ecdsa_sk" = {
        path = "/home/skarmux/.ssh/id_ecdsa_sk";
      };
    };
  };
}
