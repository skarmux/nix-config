{ pkgs, ... }: {
  # Smartcard mode
  # NOTE: Sometimes conflicts with gpg-agent
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [ gnupg yubikey-personalization ];

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  # add yubikey access rule to udev service
  services.udev.packages = with pkgs; [ yubikey-personalization ];

  # Disable ssh-agent. Will use gpg-agent instead.
  programs.ssh.startAgent = false;
}
