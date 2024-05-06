{
  description = "My typst document";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          # TODO: What is the benefit of writeScriptBin over a shell script in project root?
          buildScript = pkgs.writeScriptBin "build.sh" ''
            #!/bin/sh

            mkdir -p build
            shopt -s extglob
            for f in *.typ; do
                typst --font-path ./fonts compile $f build/''${f%%*(.typ)}.pdf
            done
          '';
          # TODO: fetch adam7/delugia-code and extract into ./fonts
        in {
          default = pkgs.mkShell {
            name = "Typst development shell";
            buildInputs = [
              pkgs.nixfmt # Keep flake.nix clean
              pkgs.typst
              pkgs.typst-lsp # Language Server
              pkgs.typst-fmt # Formater
              pkgs.zathura # PDF Viewer
              buildScript
            ];
            shellHook = ''
              echo "Run the ´build.sh´ script to compile all *.typ to PDF"
              echo "Place additional fonts inside the ./fonts folder"
              echo "Learn more about typst at https://typst.app/docs/"
            '';
          };
        });
    };
}
