{ pkgs, ... }:
{
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    sidequest
  ];

  users.users.skarmux = {
    extraGroups = [
      "adbusers"
    ];
  };
}