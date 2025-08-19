{
  imports = [
    ./helix-lsp-ai
    ./helix-file-picker.nix
    ./languages/html.nix
    ./languages/qml.nix
    ./languages/javascript.nix
    ./languages/markdown.nix
    ./languages/nix.nix
    ./languages/php.nix
    ./languages/rust.nix
    ./languages/text.nix
    ./languages/toml.nix
    ./languages/typst.nix
  ];

  programs.helix = {
    enable = true;
    settings = {
      editor = import ./editor.nix;
      # theme = lib.mkForce "base16_transparent";
      # theme = lib.mkForce "dark_plus";
      keys.normal = {
        # Allow `esc` to close multi-cursor mode
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
  };
}
