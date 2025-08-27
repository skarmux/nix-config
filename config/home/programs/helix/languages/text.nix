{
  programs.helix.languages = {
    language = [{
      name = "text";
      file-types = [ "txt" ];
      scope = "source.text";
      indent = {
        tab-width = 4;
        unit = " ";
      };
      language-servers = [ ];
      soft-wrap.enable = true;
    }];
  };
}
