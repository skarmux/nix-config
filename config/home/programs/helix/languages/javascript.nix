{
  programs.helix.languages = {
    # language-server.typescript-language-server = {
    # FIXME
    # };

    language = [{
      name = "typescript";
      file-types = [ "ts" ];
      indent = {
        tab-width = 4;
        unit = " ";
      };
      language-servers = [ "typescript-language-server" ];
      text-width = 100;
      soft-wrap.wrap-at-text-width = true;
    }];
  };
}
