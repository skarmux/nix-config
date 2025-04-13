{ pkgs, lib, config, ... }:
{
  programs.helix.languages = {
    language-server.typst-lsp = {
      command = "typst-lsp";
    };

    language = [{
      name = "typst";
      file-types = [ "typ" ];
      scope = "source.typst";
      roots = [ ];
      comment-token = "//";
      indent = {
        tab-width = 2;
        unit = " ";
      };
      formatter = {
        command = "typstfmt";
        args = [ "--output" "-" ];
      };
      auto-format = true;
      language-servers = [
        "typst-lsp"
      ] ++ (lib.optionals config.programs.helix.lsp-ai.enable [
        "lsp-ai"
      ]);
    }];

    grammar = [{
      name = "typst";
      source.path = "${pkgs.tree-sitter-grammars.tree-sitter-typst}";
    }];
  };
}
