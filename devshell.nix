{ pkgs }:

with pkgs;

devshell.mkShell {

  name = "";

  motd = ''
    Welcome!

    Commands:
    - add-skarmux: Add new user `skarmux` to the system.
  '';
  
  commands = [
    {
      name = "add-skarmux";
      help = "Add new user `skarmux` to the system, create home (-m) and user id 1026 (-u).";
      category = "system";
      command = "sudo useradd skarmux -m -u 1026 -g users -G wheel -s /usr/bin/fish";
    }
    {
      name = "keyimport";
      help = "";
      category = "";
      command = "gpg --import home/skarmux/device/yubikey/public.pgp";
    }
  ];

  bash = {
    extra = /* bash */ ''
      export GPG_TTY=$(tty)
      exec ${fish}/bin/fish
    '';
    interactive = '''';
  };

  env = [
    {
      name = "NIX_CONFIG";
      value = "extra-experimental-features = nix-command flakes";
    }
  ];

  packages = [
    home-manager
    git

    openssh
    sops
    ssh-to-age
  ];
}
