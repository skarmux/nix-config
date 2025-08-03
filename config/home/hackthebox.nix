{ pkgs, ... }:
{
    home.packages = with pkgs; [
        inetutils # ftp, etc...
        nmap # port scanning util `-sV` for version scan
        samba # access smb network shares
        redis # in-memory database
        gobuster # check web urls with wordlists
        mariadb-client
    ];
}