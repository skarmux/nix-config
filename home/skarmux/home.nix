{ inputs, self, pkgs, lib, config, ... }:
{
  imports = [
    (import self.homeModules.home {
      inherit pkgs config lib self;
      username = "skarmux";
    })
    self.homeModules.git
    self.homeModules.helix
    self.homeModules.shell
  ];

  home.file = {
    ".ssh/id_ecdsa_sk.pub".source = ./id_ecdsa_sk.pub;
    ".ssh/id_ed25519.pub".source = ./id_ed25519.pub;
  };

  sops.defaultSopsFile = ./secrets.yaml;
  sops.secrets = {
    "ssh/id_ecdsa_sk" = {
      sopsFile = ./secrets.yaml;
      path = "/home/skarmux/.ssh/id_ecdsa_sk";
    };
  };
}
