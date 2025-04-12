{ lib, config, ... }:
{
  programs.helix.languages = {
    language-server.html-language-server = {
      command = "html-language-server";
      args = [ "--stdio" ];
    };

    language = [{
      name = "html";
      file-types = [ "html" ];
      indent = {
        tab-width = 4;
        unit = " ";
      };
      language-servers = [
        "vscode-html-language-server"
        "tailwindcss-ls"
      ] ++ (lib.optionals config.programs.helix.llm [
        "lsp-ai"
      ]);
      text-width = 100;
      soft-wrap.wrap-at-text-width = true;
    }];
  };
}
