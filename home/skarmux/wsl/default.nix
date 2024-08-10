{ config, ... }:
let
  windowsUser = "skarmux";
in
{
  imports = [
    ../app/neovim
    ../yubikey
    ../global
  ];

  # Setting up anything on windows requires a bunch of work:
  # https://jardazivny.medium.com/the-ultimate-guide-to-yubikey-on-wsl2-part-2-1d9546ef23a6

  home.file = {
    ".ssh/wsl2-ssh-pageant.exe" = {
      source = ./wsl2-ssh-pageant.exe; # 2024-08-09
      executable = true;
    };
    # ".gnupg/S.gpg-agent" = {
    #   source = ./wsl2-ssh-pageant.exe; # 2024-08-09
    #   executable = true;
    # };
  };

  programs.gpg = {
    enable = true;
    # settings = {
    #   gpgConfigBasepath = "C\\:/Users/${windowsUser}/AppData/Local/gnupg"; 
    #   gpg = "S.gpg-agent";
    # };
  };

  programs.bash.bashrcExtra = let
  in /* bash */ ''
    config_path="C\:/Users/${windowsUser}/AppData/Local/gnupg"
    wsl2_ssh_pageant_bin="${config.home.homeDirectory}/.ssh/wsl2-ssh-pageant.exe"

    # SSH Socket
    # Removing Linux SSH socket and replacing it by link to wsl2-ssh-pageant socket
    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
    if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
      rm -f "$SSH_AUTH_SOCK"
      if test -x "$wsl2_ssh_pageant_bin"; then
        (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
      else
        echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
      fi
    fi

    # GPG Socket
    # Removing Linux GPG Agent socket and replacing it by link to wsl2-ssh-pageant GPG socket
    export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
    if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
      rm -rf "$GPG_AGENT_SOCK"
      if test -x "$wsl2_ssh_pageant_bin"; then
        (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpgConfigBasepath ${config_path} --gpg S.gpg-agent" >/dev/null 2>&1 &)
      else
        echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
      fi
    fi
  '';
}
