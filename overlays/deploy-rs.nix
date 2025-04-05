{ inputs, ... }:
(final: prev: {
  deploy-rs = import inputs.nixpkgs {
    inherit (prev) deploy-rs;
    lib = prev.deploy-rs.lib;
  };
})
