# Connect devices using the cli: https://gist.github.com/Jonny-exe/9bad76c3adc6e916434005755ea70389
{
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--gui-address=0.0.0.0:8384"
    ];
  };
}
