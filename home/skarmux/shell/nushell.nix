{
  programs.nushell = {
    configFile.text = ''
      $env.config = {
        show_banner: false,
      }
    '';
  };
}
