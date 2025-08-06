{ pkgs, ... }:
{
    home.packages = with pkgs; [
        timewarrior
        taskwarrior3
    ];

    # Empty config file gets automatically generated on first
    # invocation of `timew`
    # home.file.".config/timewarrior/timewarrior.cfg".text = "";
}