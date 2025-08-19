{ config, lib, ... }:
{
  programs.direnv = {
    # Prevent project dependencies from being
    # garbage collected and speed up execution
    nix-direnv.enable = true;
    silent = true;

    enableNushellIntegration = true;
    enableBashIntegration = true;
  };

  programs.git.ignores = lib.mkIf config.programs.direnv.enable [ ".direnv/**" ];
}
