{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security = {
    # pam.services.login.esableGnomeKeyring = true;
  };
}
