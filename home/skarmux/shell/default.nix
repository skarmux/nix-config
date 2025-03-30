{ config, pkgs, ... }:
let
  # Abbreviations get auto-expanded to the full command in
  # shells that support it like fish shell.
  shellAbbrs = {
    jqless = "jq -C | less -r";
    hms = "home-manager --flake . switch";
    snrs = "sudo nixos-rebuild --flake . switch";
    snrt = "sudo nixos-rebuild --flake . test";
    snrb = "sudo nixos-rebuild --flake . boot";
  };

  shellAliases = {
    ".." = "cd ..";
    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";
  };

in
{
  imports = [
    ./bash.nix
    ./fish.nix
    ./nushell.nix
  ];
  
  programs = {
    fish = { inherit shellAbbrs shellAliases; };
    bash = { shellAliases = shellAliases // shellAbbrs; };
    nushell = { shellAliases = shellAliases // shellAbbrs; };
  };
}
