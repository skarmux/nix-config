{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utilsi }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
          # config.allowUnfree = true;
        };

        buildInputs = with pkgs;
          [ ]; # compile time & runtime (ex: openssl, sqlite)
        nativeBuildInputs = with pkgs; [ ]; # compile time

        commonArgs = { inherit src buildInputs nativeBuildInputs; };

        dockerImage = pkgs.dockerTools.buildImage {
          name = "template";
          tag = "latest";
          copyToRoot = [ bin ];
          config = { Cmd = [ "${bin}/bin/template" ]; };
        };
      in {
        packages = {
          inherit bin dockerImage;
          default = bin;
        };

        devShells.default = pkgs.mkShell {
          # inherit buildInputs nativeBuildInputs;
          # shellHook = ''
          #   echo "Let's get Rusty"
          # '';
          inputsFrom = [ bin ];
          buildInputs = with pkgs; [ jdk20 jetbrains.idea-community dive ];
        };
      });
}
