{
  description = "My Project";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; };

  outputs = { nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in {
      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell { buildInputs = with pkgs; [ nixfmt ]; };
        });
    };
}
