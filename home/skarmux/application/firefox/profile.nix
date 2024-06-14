{ config, lib, ... }:
{
  imports = [ ./arkenfox.nix ];

  programs.firefox.profiles.${config.home.username} = {
    isDefault = true;
    search = {
      force = true;
      default = "https://search.brave.com";
    };
    settings = {
      # Override Arkenfox Config
      "extensions.getAddons.showPane" = lib.mkForce true;
      "webgl.disabled" = lib.mkForce false;

      "browser.startup.homepage_override.mstone" = "ignore";
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      "browser.urlbar.showSearchTerms.enabled" = false;
      "browser.topsites.contile.enabled" = false;
      "browser.search.suggest.enabled" = false;
      "browser.search.suggest.enabled.private" = false;
      "browser.urlbar.showSearchSuggestionsFirst" = false;
      # "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      # "browser.newtabpage.activity-stream.feeds.snippets" = false;
      # "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
      # "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
      # "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
      # "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
      # "browser.newtabpage.activity-stream.system.showSponsored" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.translations.neverTranslateLanguages" = "de";
      "browser,disableResetPrompt" = true;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.shell.defaultBrowserCheckCount" = 1;
      "browser.disableResetPrompt" = true;
      "browser.download.panel.shown" = true;
      "privacy.trackingprotection.enabled" = true;
      "signon.rememberSignons" = false;
      "extensions.pocket.enabled" = false;
      "extensions.screenshots.disabled" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "identity.sync.tokenserver.uri" = "https://syncstorage.skarmux.tech/1.0/sync/1.5";
      # "identity.fxaccounts.enabled" = false;
    };

    userChrome = ''
      /* Hide tabs in favor of sidebery extension */
      #TabsToolbar { display: none; }

      /* Hide header in (sidebery) sidebar */
      #sidebar-box #sidebar-header { display: none !important; }

      .navigator-toolbox { display: none !important; }
      .sidebar-splitter { display: none !important; }
    '';
  };
}
