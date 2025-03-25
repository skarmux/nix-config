{ pkgs, ... }:
{
  pkgs.mkShell {
    name = "Disko";
    buildInputs = with pkgs; [
      disko
    ];
    shellHook = ''
      echo "Disko Shell"
      alias disko="sudo nix run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#ignika"
    '';
  };
}

