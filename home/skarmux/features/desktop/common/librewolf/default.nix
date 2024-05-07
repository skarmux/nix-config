{
  programs.librewolf = {
    enable = true;
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.toolbars.bookmarks.visibility" = "never";
    };
  };

  # userChrome.css
  # TODO: profile name is random and will change
  # home.file.".librewolf/uksotxrd.default/chrome".source = ./chrome;

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "librewolf.desktop" ];
    "text/xml" = [ "librewolf.desktop" ];
    "x-scheme-handler/http" = [ "librewolf.desktop" ];
    "x-scheme-handler/https" = [ "librewolf.desktop" ];
  };
}
