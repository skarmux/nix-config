# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ inputs, lib, ... }:

{
  imports = [
    # include NixOS-WSL modules
    #<nixos-wsl/modules>
    inputs.nixos-wsl.nixosModules.default
    ../common/global
    ../common/users/skarmux
  ];

  users.users.skarmux = {
    password = "deck";
    hashedPasswordFile = lib.mkForce null;
  };

  boot = {
    # Enable deployment to Raspberry Pi 4 (ARM64)
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  wsl = {
    enable = true;
    defaultUser = "skarmux";
  };

  networking.hostName = "wsl";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
