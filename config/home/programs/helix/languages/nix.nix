{ pkgs, ... }:
{
  programs.helix.languages = {
    language-server.nixd = {
      command = "nixd";
    };

    language = [{
      name = "nix";
      file-types = [ "nix" ];
      scope = "source.nix";
      roots = [ "flake.nix" ];
      comment-token = "#";
      indent = {
        tab-width = 2;
        unit = " ";
      };
      formatter = {
        command = "nixfmt";
        # args = [ "--output" "-" ];
      };
      auto-format = true;
      auto-pairs = {
        "(" = ")";
        "{" = "}";
        "[" = "]";
        "\"" = "\"";
        "`" = "`";
        "<" = ">";
        "=" = ";";
      };
      language-servers = [
        "nixd"
      ];
    }];

    grammar = [{
      name = "nix";
      source.path = "${pkgs.tree-sitter-grammars.tree-sitter-nix}";
    }];
  };
}
