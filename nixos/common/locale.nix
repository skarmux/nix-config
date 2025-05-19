{ lib, ... }:
{
  time.timeZone = lib.mkDefault "Europe/Berlin";

  i18n = {
    supportedLocales = [
      # https://sourceware.org/git/?p=glibc.git;a=blob;f=localedata/SUPPORTED
      "de_DE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "ja_JP.EUC-JP/EUC-JP"
      "ja_JP.UTF-8/UTF-8"
    ];
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };
}
