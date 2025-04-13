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
      ] ++ (lib.optionals config.programs.helix.lsp-ai.enable [
        "lsp-ai"
      ]);
      text-width = 100;
      soft-wrap = {
        enable = true;
        wrap-at-text-width = true;
      };
    }];
  };
}
