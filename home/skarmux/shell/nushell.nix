{
  programs.nushell = {
    configFile.text = ''
      $env.config = {
        show_banner: false,
      }
    '';
  };

  programs = {
    direnv.enableNushellIntegration = true;
    eza.enableNushellIntegration = true;
    starship.enableNushellIntegration = true;
    thefuck.enableNushellIntegration = true;
    yazi.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;
  };
}
