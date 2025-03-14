{ pkgs, config, ... }:
{
  imports = [
    ./gpg.nix
  ];

  home = {
    packages = with pkgs; [
      yubikey-personalization
      yubikey-manager
      yubikey-agent
    ];
    file = {
      ".ssh/id_ecdsa_sk.pub".source = ./id_ecdsa_sk.pub;
      ".ssh/id_ed25519.pub".source = ./id_ed25519.pub;
    };
  };

  sops.secrets."ssh/id_ecdsa_sk" = {
    sopsFile = ../secrets.yaml;
    path = "${config.home.homeDirectory}/.ssh/id_ecdsa_sk";
  };
}
