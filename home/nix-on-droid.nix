{ self, lib, ... }:
{
  imports = [
    ./common/git
    ./common/helix
    ./common/shell
  ]
  ++ builtins.attrValues self.homeModules;
  
  home = {
    username = "nix-on-droid";
    homeDirectory = "/data/data/com.termux.nix/files/home";
    stateVersion = "24.11";
  };

  nixpkgs.config = {
    # cache.nixos.org does not process unfree packages which
    # requires the host to build them
    # Not sure about the cachix cache though...

    allowUnfree = lib.mkForce false;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "unrar"
    ];
  };

  programs = {
    git.enable = true;
    helix = {
      enable = true;
      defaultEditor = true;
      file-picker = "tmux";
    };
  };

  systemd.user.startServices = "sd-switch";
}
