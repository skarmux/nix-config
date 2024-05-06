{ pkgs, ... }: {
  programs.firefox = {
    enable = true;

    package = pkgs.firefox;

    profiles."skarmux" = {

      extensions = with pkgs.inputs.firefox-addons; [
        ublock-origin # block ads
        i-dont-care-about-cookies # eliminate EU bullshit
        keepassxc-browser # password manager
      ];

      # search.force = true;
      # search.default = "Kagi";
      # search.engines = {
      #   "Wikipedia (en)".hidden = true;
      #   "Google".metaData.hidden = true;
      #   "Amazon.com".metaData.hidden = true;
      #   "Amazon.co.uk".metaData.hidden = true;
      #   "Bing".metaData.hidden = true;
      #   "eBay".metaData.hidden = true;
      #   "DuckDuckGo".metaData.hidden = true;
      #   "Nix Packages" = {
      #     urls = [{
      #       templates = "https://search.nixos.org/packages";
      #       params = [
      #         {
      #           name = "type";
      #           value = "packages";
      #         }
      #         {
      #           name = "query";
      #           value = "{searchTerms}";
      #         }
      #       ];
      #     }];
      #     icon =
      #       "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #     definedAliases = [ "@np" ];
      #   };
      # };

      settings = {
        "browser,disableResetPrompt" = true;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage" = "https://start.duckduckgo.com";
        "dom.security.https_onlz_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
        "signon.rememberSignons" = false;
        "network.captive-portal-service.enabled" = false;
      };

      userChrome = "";
      userContent = "";
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

}
