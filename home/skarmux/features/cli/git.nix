{ pkgs, config, ... }:
{
  programs.git = {
    enable = true;

    userName = "Nils Harbke";
    userEmail = "nils.harbke@proton.me";

    extraConfig = {
      # key is stored on Yubikey
      user.signing.key = "A6C555DD3AA48325B616A1D8F822D479719EAB61";
      pager = { branch = "false"; };
      # safe = { directory = config.configPath; };
      pull = { ff = "only"; };
      push = { autoSetupRemote = "true"; };
      init = { defaultBranch = "master"; };
      commit = { gpgSign = false; };

      safe.directory = "/etc/nixos";
    };

    # Git Large File Storage
    lfs.enable = true;

    ignores = [ ".direnv/**" "result" "target" ];
  };

  sops.secrets."git/ssh/id_ecdsa_sk" = {
    sopsFile = ../../secrets.yaml;
    path = "${config.home.homeDirectory}/.ssh/id_ecdsa_sk";
  };

  home.file = {
    ".ssh/id_ecdsa_sk.pub".source = ../../yubikey/id_ecdsa_sk.pub;
    # ".ssh/id_ecdsa_sk".source = config.sops.secrets."git/ssh/id_ecdsa_sk".path;
  };

  home.packages = with pkgs; [ git-crypt ];

  programs.gitui = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.git.delta = {
    enable = true;
    catppuccin.enable = true;
  };

}
