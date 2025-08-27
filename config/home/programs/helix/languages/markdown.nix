{
  programs.helix.languages = {
    language-server.marksman = {
      command = "marksman";
    };

    language = [{
      name = "markdown";
      file-types = [ "md" ];
      indent = {
        tab-width = 4;
        unit = " ";
      };
      language-servers = [
        "marksman"
      ];
      text-width = 100;
      soft-wrap.enable = true;
    }];
  };
}
