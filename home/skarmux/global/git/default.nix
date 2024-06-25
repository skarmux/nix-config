{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;

      userName = "Nils Harbke";
      userEmail = "nils.harbke@proton.me";

      extraConfig = {
        user.signing.key = "A6C555DD3AA48325B616A1D8F822D479719EAB61";
        pager = { branch = "false"; };
        pull = { ff = "only"; };
        push = { autoSetupRemote = "true"; };
        init = { defaultBranch = "main"; };
        commit = { 
          gpgSign = false; 
          template = "~/.gitmessage";
        };
      };

      hooks = {
        # pre-commit = pkgs.writeShellScriptBin "gitleaks-check.sh" ''
        # ${pkgs.gitleaks}/bin/gitleaks protect --verbose --redact
        # if [ $? -eq 1]; then
        #   echo "ERROR: gitleaks has detected sensitive information in your commits!"
        #   exit 1
        # fi
        # '';
      };

      # [Git Large File Storage]
      # Reduce size of git repository history by storing 
      # large files outside of version control with link
      lfs.enable = true;

      # Improve `git diff` syntax highlighting and styling
      delta.enable = true;
    };

    lazygit.enable = true;
  };

  home = {
    file.".gitmessage".source = ./gitmessage.txt;
    packages = with pkgs; [
      git-crypt 
      gitleaks
    ];
  };
}
