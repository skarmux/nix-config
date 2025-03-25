{ config, lib, ... }:
{
  programs = {
    direnv = {
      enable = true;
      # Prevent project dependencies from being
      # garbage collected and speed up execution
      nix-direnv.enable = true;
    };

    git.ignores = [ ".direnv/**" ];
  };

  # home.persistence = {
  #  "/nix/persist/home/skarmux" = {
  #    directories = [
  #      {
  #        directory = ".local/share/direnv/allow";
  #        method = "symlink"; 
  #      } 
  #    ];
  #   };
  # };
}
