{ inputs, ... }:
{
  flake.overlays = {
    deploy-rs = import ./deploy-rs.nix { inherit inputs; };
  };
}
