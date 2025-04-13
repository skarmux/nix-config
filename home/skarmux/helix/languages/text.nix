{ lib, config, ... }:
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
      language-servers = [ ] ++ (lib.optionals config.programs.helix.lsp-ai.enable [
        "lsp-ai"
      ]);
      soft-wrap.enable = true;
    }];
  };
}
