{ config, lib, ... }:
{
  programs.direnv = {
    # Prevent project dependencies from being
    # garbage collected and speed up execution
    nix-direnv.enable = true;
  };

  programs.git.ignores = lib.mkIf config.programs.direnv.enable [ ".direnv/**" ];
}
