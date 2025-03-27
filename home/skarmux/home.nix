{ inputs, self, pkgs, lib, config, ... }:
{
  imports = [
    (import self.homeModules.home {
      inherit pkgs config lib self;
      username = "skarmux";
    })
    self.homeModules.git
    self.homeModules.helix
    self.homeModules.shell
  ];
}
