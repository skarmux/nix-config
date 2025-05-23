{ pkgs, config, lib, ... }:
let
  # Abbreviations get auto-expanded to the full command in
  # shells that support it like fish shell.
  shellAbbrs = {
    jqless = "${pkgs.jq}/bin/jq -C | ${pkgs.less}/bin/less -r";
    hms = "${pkgs.home-manager}/bin/home-manager --flake . switch";
    snrs = "sudo nixos-rebuild --flake . switch";
    snrt = "sudo nixos-rebuild --flake . test";
    snrb = "sudo nixos-rebuild --flake . boot";
  };

  shellAliases = {
    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";
    cd = lib.mkIf config.programs.zoxide.enable "z";
    cat = lib.mkIf config.programs.bat.enable "bat";
    # ls-alias provided by programs.eza.enable<shell>Integration
  };
in
{
  imports = [
    ./bash.nix
    ./compression.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./nushell.nix
    ./tmux.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    jq
    fd
    ripgrep
    ripgrep-all
  ];
  
  programs = {
    fish = { inherit shellAbbrs shellAliases; };
    bash = { shellAliases = shellAliases // shellAbbrs; };
    nushell = { shellAliases = shellAliases // shellAbbrs; };
    bat.enable = true;
    tmux.enable = true;
    eza.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
  };
}
