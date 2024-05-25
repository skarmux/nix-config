{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;

      userName = "Nils Harbke";
      userEmail = "nils.harbke@proton.me";

      extraConfig = {
        # key is stored on Yubikey
        user.signing.key = "A6C555DD3AA48325B616A1D8F822D479719EAB61";
        pager = { branch = "false"; };
        pull = { ff = "only"; };
        push = { autoSetupRemote = "true"; };
        init = { defaultBranch = "master"; };
        commit = { gpgSign = false; };

        # TODO: Lookup definition
        safe.directory = "/etc/nixos";
      };

      # Git Large File Storage
      lfs.enable = true;

      ignores = [ ".direnv/**" "result" "target" ];
    };

    # NOTE: gitui is not compatible with SSH keys yet.
    # gitui = {
    #   enable = true;
    #   catppuccin.enable = true;
    # };

    lazygit.enable = true;

    # Improve `git diff` syntax highlighting and styling
    git.delta = {
      enable = true;
      catppuccin.enable = true;
    };
  };

  home.packages = with pkgs; [ git-crypt ];
}
