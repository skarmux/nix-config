{
  programs = {

    # Aliases: ls, ll, la, lt, lla
    eza.enableNushellIntegration = true;
    
    yazi.enableNushellIntegration = true;
    direnv.enableNushellIntegration = true;
    starship.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;

    nushell = {
      enable = true;

      configFile.text = ''
        $env.config = {
          show_banner: false,
        }
      '';

      shellAliases = {

        # JSON in scroll buffer with highlights
        # TODO: Pipeline breaks nushell config
        # jqless = "jq -C | less -r";

        nd = "nix develop -c $env.SHELL";
        nb = "nix build";
        nc = "nix flake check";

        snrs = "sudo nixos-rebuild --flake . switch";
        snrt = "sudo nixos-rebuild --flake . test";
        snrb = "sudo nixos-rebuild --flake . boot";

        hms = "home-manager --flake . switch";

        z = "zoxide";
        y = "yazi";
        n = "nvim";
        ng = "nvim -c Neogit";

        # Interactive -i to prevent accidental overrides
        cp = "cp -i";
        mv = "mv -i";
        rm = "rm -i";
      };
    };
  };
}
