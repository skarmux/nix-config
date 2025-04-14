{
  programs.helix = {
    settings = {
      editor = import ./editor.nix;
      keys.normal = {
        # Allow `esc` to close multi-cursor mode
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
  };

  imports = [
    ./languages/html.nix
    ./languages/javascript.nix
    ./languages/markdown.nix
    ./languages/nix.nix
    ./languages/php.nix
    ./languages/rust.nix
    ./languages/text.nix
    ./languages/toml.nix
    ./languages/typst.nix
  ];
}

