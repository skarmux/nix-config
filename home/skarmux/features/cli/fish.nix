{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  hasNeovim = config.programs.neovim.enable || config.programs.nixvim.enable;
  hasHelix = config.programs.helix.enable;
in {
  # Packages used in abbreviations and aliases
  home.packages = with pkgs; [ jq p7zip unrar unzip grc ];

  programs.fish = {
    enable = true;

    shellAbbrs = {
      jqless = "jq -C | less -r";

      nd = "nix develop -c $SHELL";
      ns = "nix shell";
      nsn = "nix shell nixpkgs#";
      nb = "nix build";
      nbn = "nix build nixpkgs#";
      nf = "nix flake";

      nr = "nixos-rebuild --flake .";
      nrs = "nixos-rebuild --flake . switch";
      snr = "sudo nixos-rebuild --flake .";
      snrs = "sudo nixos-rebuild --flake . switch";
      hm = "home-manager --flake .";
      hms = "home-manager --flake . switch";

      n = mkIf hasNeovim "nvim";
      h = mkIf hasHelix "hx";
    };

    shellAliases = {
      bash = "${pkgs.bashInteractive}/bin/bash";

      # Clear screen and scrollback
      clear = "printf '\\033[2J\\033[3J\\033[1;1H'";

      # Shorter `cd`
      ".." = "cd ..";
      "..2" = "cd ../..";
      "..3" = "cd ../../..";
      "..4" = "cd ../../../..";
      "..5" = "cd ../../../../..";

      # Interactive `cp` to prevent accidental overrides
      cp = "cp -i";

      # Power cycling
      ssn = "sudo shutdown now";
      sr = "sudo reboot";
    };

    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
    ];

    functions = {
      # Disable greeting
      fish_greeting = "";

      # Combine all extraction commands
      # ex = ''
      #   if [ -f $1 ] ; then
      #     case $1 in
      #       *.tar.bz2) tar xjf $1 ;;
      #       *.tar.gz) tar xzf $1 ;;
      #       *.bz2) bunzip2 $1 ;;
      #       *.rar) unrar x $1 ;;
      #       *.gz) gunzip $1 ;;
      #       *.tar) tar xf $1 ;;
      #       *.tbz2) tar xjf $1 ;;
      #       *.tgz) tar xzf $1 ;;
      #       *.zip) unzip $1 ;;
      #       *.Z) uncompress $1 ;;
      #       *.7z) 7z x $1 ;;
      #       *.deb) ar xf $1 ;;
      #       *.tar.xz) tar xf $1 ;;
      #       *.tar.zst) unzstd $1 ;;
      #       *) echo "'$1' cannot be extracted via ex()" ;;
      #     esac
      #   else
      #     echo "'$1' is not a valid file"
      #   fi
      # '';
      #
    };

  };
}
