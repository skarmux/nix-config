{lib, ...}:
{
  programs.nixvim.plugins = {
    # Check crate versions in `Cargo.toml`
    crates-nvim.enable = true;

    # Feature package on top of lsp
    # Overview: https://github.com/mrcjkb/rustaceanvim#books-usage--features
    rustaceanvim = {
      enable = true;
    };

    lsp.servers = {
      rust-analyzer = {
        enable = lib.mkForce false;
      };
    };
  };
}
