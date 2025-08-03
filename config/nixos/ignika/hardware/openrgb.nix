{ pkgs, ... }:
let
  no-rgb = pkgs.writeScriptBin "no-rgb" ''
    #!/bin/sh
    NUM_DEVICES=$(${pkgs.openrgb}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

    for i in $(seq 0 $(($NUM_DEVICES - 1))); do
      ${pkgs.openrgb}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
    done
  '';
in
{
  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
  ];

  services.udev.packages = [ pkgs.openrgb ];
  boot.kernelModules = [ "i2c-dev" ];
  hardware.i2c.enable = true;

  systemd.services.no-rgb = {
    description = "no-rgb";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${no-rgb}/bin/no-rgb";
      Type = "oneshot";
    };
  };
}
