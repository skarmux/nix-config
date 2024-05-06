{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, crane }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
          # config.allowUnfree = true;
        };

        rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile
          ./rust-toolchain.toml;

        craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;
        src = craneLib.cleanCargoSource ./.;

        # end2end-raw = (pkgs.callPackage ./end2end/default.nix { })."@playwright/test-1.28.0";
        # end2end = end2end-raw.overrideAttrs(oa: {
        #   nativeBuildInputs = oa.nativeBuildInputs or [] ++ [
        #     pkgs.makeWrapper
        #   ];
        #   postInstall = ''
        #     wrapProgram $out/bin/playwright \
        #       --set-default PLAYWRIGHT_BROWSER_PATH "${playwrightBrowsers}" \
        #       --prefix NODE_PATH : ${placeholder "out"}/lib/node_modules
        #   '';
        # });

        buildInputs = with pkgs; [
          openssl
          pkg-config
          cacert
          cargo-generate
          cargo-leptos
          trunk # client-side rendering
        ]; # compile time & runtime (ex: openssl, sqlite)
        nativeBuildInputs = with pkgs; [
          rustToolchain
          pkg-config
          sass # compile scss style classes, etc.
        ]; # compile time

        commonArgs = { inherit src buildInputs nativeBuildInputs; };
        cargoArtifacts = craneLib.buildDepsOnly commonArgs;

        bin = craneLib.buildPackage (commonArgs // { inherit cargoArtifacts; });

        dockerImage = pkgs.dockerTools.buildImage {
          name = "template";
          tag = "latest";
          copyToRoot = [ bin ];
          config = { Cmd = [ "${bin}/bin/template" ]; };
        };

        buildNodeJs =
          pkgs.callPackage "${nixpkgs}/pkgs/development/web/nodejs/nodejs.nix" {
            python = pkgs.python3;
          };

        nodejs = buildNodeJs {
          enableNpm = true;
          version = "20.5.1";
          sha256 = "sha256-Q5xxqi84woYWV7+lOOmRkaVxJYBmy/1FSFhgScgTQZA=";
        };
      in {
        packages = {
          inherit bin dockerImage;
          default = bin;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ bin ];
          buildInputs = with pkgs; [
            dive # analyze docker images
            nodejs
            # nodePackages.node2nix
            playwright-test
          ];
          # PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}";
          RUST_SRC_PATH =
            "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
          # shellHook = ''
          #   echo "Let's get Rusty" \
          #   rm node_modules/@playwright/ -R
          # '';
        };
      });
}
