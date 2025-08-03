{ lib, config, ... }:
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
      ] ++ (lib.optionals config.programs.helix.lsp-ai.enable [
        "lsp-ai"
      ]);
      text-width = 100;
      soft-wrap.enable = true;
    }];
  };
}
