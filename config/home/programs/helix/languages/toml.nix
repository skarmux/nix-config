{
  programs.helix.languages = {
    language-server.taplo = {
      command = "taplo";
    };
    language = [{
      name = "toml";
      file-types = [ "toml" ];
      indent = {
        tab-width = 4;
        unit = " ";
      };
      text-width = 80;
      auto-format = true;
      language-servers = [
        "taplo"
      ];
      soft-wrap = {
        enable = true;
        wrap-at-text-width = true;
      };
    }];
  };
}
