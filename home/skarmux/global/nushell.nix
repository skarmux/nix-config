{ pkgs, ... }:
{
  programs = {
    eza.enableNushellIntegration = true;
    yazi.enableNushellIntegration = true;
    direnv.enableNushellIntegration = true;
    starship.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;

    nushell = {
      enable = true;
      shellAliases = {

        # JSON in scroll buffer with highlights
        jqless = "jq -C | less -r";

        nd = "nix develop -c $SHELL";
        ns = "nix shell";
        nsn = "nix shell nixpkgs#";
        nb = "nix build";
        nbn = "nix build nixpkgs#";
        nf = "nix flake";

        snrs = "sudo nixos-rebuild --flake . switch";
        snrt = "sudo nixos-rebuild --flake . test";
        snrb = "sudo nixos-rebuild --flake . boot";

        hms = "home-manager --flake . switch";

        # cd = "z";
        n = "nvim";
        y = "yazi";
        # h = "hx";

        # Interactive -i to prevent accidental overrides
        cp = "cp -i";
        mv = "mv -i";
        rm = "rm -i";

        tree = "eza --tree";
      };
    };
  };
}
