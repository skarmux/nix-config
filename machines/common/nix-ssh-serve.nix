{
  nix = {
    sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOHnEYhX+q+xTVjoIIAjT+tn1NVAtqLjkE8J88YS14w skarmux"
      ];
      protocol = "ssh";
      write = true;
    };
    settings.trusted-users = ["nix-ssh"];
  };
}
