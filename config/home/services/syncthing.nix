{
  services.syncthing = {
    enable = true;
    # https://docs.syncthing.net/users/syncthing.html
    extraOptions = [
      "--gui-address=https://127.0.0.1:8384"
      "--no-default-folder"
    ];
  };
}