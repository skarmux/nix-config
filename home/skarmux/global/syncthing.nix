# Connect devices using the cli: https://gist.github.com/Jonny-exe/9bad76c3adc6e916434005755ea70389
{
  services.syncthing = {
    enable = true;
    extraOptions = []; # default
  };

  home.persistence."/nix/persist/home/skarmux" = {
    directories = [
      ".local/state/syncthing"
    ];
  };
}
