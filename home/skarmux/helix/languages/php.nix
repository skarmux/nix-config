{
  programs.helix.languages = {
    language-server.phpactor = {
      command = "phpactor";
      args = [ "--stdio" ];
      config = {
        language_server_worse_reflection.inlay_hints = {
          enable = true;
          types = true;
          params = true;
        };
      };
    };
    language = [ ];
  };
}
