{
  programs.helix.languages = {
    language = [{
      name = "toml";
      file-types = [ "toml" ];
      indent = {
        tab-width = 4;
        unit = " ";
      };
      text-width = 80;
      auto-format = true;
    }];
  };
}
