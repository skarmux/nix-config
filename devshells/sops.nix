{ pkgs, ... }:
pkgs.mkShell {
  name = "SOPS";
  buildInputs = with pkgs; [
    helix
    sops
    ssh-to-age
    gnupg
    pinentry-curses
    age
  ];
  shellHook = ''
    echo "Sops Shell"      
  '';
}
