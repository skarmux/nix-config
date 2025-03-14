{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ greetd.tuigreet ];

  # Configure Auto-Login
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "Hyprland";
        user = "skarmux";
      };
      # Default session fallback to non-graphical tuigreet
      # for passing GPU to qemu instance (see kvm.nix)
      default_session = {
        command = "tuigreet --cmd fish";
        user = "skarmux";
      };
      restart = true;
    };
  };
}
