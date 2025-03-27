{ pkgs, ... }:
{
  imports = [ ./btop.nix ];

  home.packages = with pkgs; [
    stui  # stress testing
    htop
    atop
    iftop # network traffic
    iotop # disk activity
    nvtop # amd/intel/nvidia
    csysdig
    linux-perf
    wavemon # wifi
  ];
}
