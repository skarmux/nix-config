{ pkgs, ... }:
{
  imports = [
    ./btop.nix
  ];

  home.packages = with pkgs; [
    htop
    atop
    iftop # network traffic
    iotop # disk activity
    nvtopPackages.full # amd/intel/nvidia
    sysdig
    # linux-perf is a kernel package
    wavemon # wifi
    dust # disk usage
  ];
}
