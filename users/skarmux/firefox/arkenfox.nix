{ config, ... }:
{
  programs.firefox.profiles.${config.home.username}.settings = {
    # STARTUP
    "browser.aboutConfig.showWarning" = false;
    "browser.startup.page" = 0; # 0=blank, 1=home, 2=last visited page, 3=restore session
    "browser.startup.homepage" = "about:blank";
    "browser.newtabpage.enabled" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.default.sites" = "";

    # GEO LOCATION
    "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
    "geo.provider.ms-windows-location" = false; # [WINDOWS]
    "geo.provider.use_corelocation" = false; # [MAC]
    "geo.provider.use_gpsd" = false; # [LINUX] [HIDDEN PREF]
    "geo.provider.use_geoclue" = false; # [FF102+] [LINUX]

    # QUIETER FOX
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendation.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.shopping.experience2023.enabled" = false;

    # TELEMETRY
    "datareporting.policy.dataSubmissionEnabled" = false;
    "toolkit.telementry.unified" = false;
    "toolkit.telementry.enabled" = false;
    "toolkit.telementry.server" = false;
    "toolkit.telementry.archive.enabled" = false;
    "toolkit.telementry.newProfilePing.enabled" = false;
    "toolkit.telementry.shutdownPingSender.enabled" = false;
    "toolkit.telementry.updatePing.enabled" = false;
    "toolkit.telementry.bhrPing.enabled" = false;
    "toolkit.telementry.firstShutdownPing.enabled" = false;
    "toolkit.telementry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;

    # STUDIES
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    # CRASH REPORTS
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

    # OTHER
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = false;
    "network.connectivity-service.enabled" = false;

    # SAFE BROWSING
    "browser.safebrowsing.downloads.remote.enabled" = false;
    "network.prefetch-next" = false;
    "network.dns.disablePrefetch" = true;
    "network.predictor.enabled" = false;
    "network.predictor.enable-prefetch" = false;
    "network.http.speculative-parallel-limit" = 0;
    "browser.places.speculativeConnect.enabled" = false;

    # DNS / DoH / POXY / SOCKS
    "network.proxy.socks_remote_dns" = true;
    "network.file.disable_unc_paths" = true;
    "network.gio.supported-protocols" = "";

    # LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.search.suggest.enaled" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.trending.featureGate" = false;
    "browser.urlbar.addons.featureGate" = false;
    "browser.urlbar.mdn.featureGate" = false;
    "browser.urlbar.pocket.featureGate" = false;
    "browser.urlbar.weather.featureGate" = false;
    "browser.urlbar.yelp.featureGate" = false;
    "browser.formfill.enable" = false;
    "browser.search.separatePrivateDefault" = true;
    "browser.search.separatePrivateDefault.ui.enabled" = true;

    # PASSWORDS
    "signon.autofillForms" = false;
    "signon.formlessCapture.enabled" = false;
    "network.auth.subresource-http-auth-allow" = 1;

    # DISK AVOIDANCE
    # "browser.cache.disk.enable" = false;
    # "browser.privatebrowsing.forceMediaMemoryCache" = true;
    # "media.memory_cache_max_size" = 65536;
    # "browser.sessionsstore.privacy_level" = 2;
    # "browser.shell.shortcutFavicons" = false;

    # HTTPS (SSL/TLS, OCSP / CERTS / HPKP )
    "security.ssl.require_safe_negotiation" = true;
    "security.tls.enable_0rtt_data" = false;

    # OCSP (Online Certificate Status Protocol)
    "security.OCSP.enabled" = 1;
    "security.OCSP.require" = true;

    # CERTS / HPKP (HTTP Public Key Pinning)
    "security.cert_pinning.enforcement_level" = 2;
    "security.remote_settings.crlite_filters.enabled" = true;
    "security.pki.crlite_mode" = 2;

    # MIXED CONTENT
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_send_http_background_request" = false;

    # UI
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "browser.xul.error_pages.expert_bad_cert" = true;

    # REFERERS
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    # CONTAINERS
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;

    # PLUGINS / MEDIA / WEBRTC
    "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
    "media.peerconnection.ice.default_address_only" = true;

    # DOM (Document Object Model)
    "dom.disable_window_move_resize" = true;

    # MISCELLANEOUS
    "browser.download.start_downloads_in_tmp_dir" = true;
    "browser.helperApps.deleteTempFileOnExit" = true;
    "browser.uitour.enabled" = false;
    "devtools.debugger.remote-enabled" = false;
    "permissions.manager.defaultsUrl" = "";
    "webchannel.allowObject.urlWhitelist" = "";
    "network.IDN_show_punycode" = true;
    "pdfjs.disabled" = false;
    "pdfjs.enableScripting" = false;
    "browser.tabs.searchclipboardfor.middleclick" = false;
    "browser.contentanalysis.default_allow" = false;

    # DOWNLOADS
    "browser.download.useDownloadDir" = false;
    "browser.download.alwaysOpenPanel" = false;
    "browser.download.manager.addToRecentDocs" = false;
    "browser.download.always_ask_before_handling_new_types" = true;

    # EXTENSIONS
    "extensions.enableScopes" = 5;
    "extensions.postDownloadThirdPartyPrompt" = false;

    # ETP (Enhanced Tracking Protection)
    "browser.contentblocking.category" = "strict";

    # SHUTDOWN & SANITIZING
    "privacy.sanitize.sanitizeOnShutdown" = true;
    "privacy.clearOnShutdown.cache" = true;
    "privacy.clearOnShutdown_v2.cache" = true;
    "privacy.clearOnShutdown.downloads" = true;
    "privacy.clearOnShutdown.formdata" = true;
    "privacy.clearOnShutdown.history" = true;
    "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
    "privacy.clearOnShutdown.cookies" = true;
    "privacy.clearOnShutdown.offlineApps" = true;
    "privacy.clearOnShutdown.sessions" = true;
    "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
    "privacy.clearSiteData.cache" = true;
    "privacy.clearSiteData.cookiesAndStorage" = false;
    "privacy.clearSiteData.historyFormDataAndDownloads" = true;
    "privacy.cpd.cache" = true;
    "privacy.clearHistory.cache" = true;
    "privacy.cpd.formdata" = true;
    "privacy.cpd.history" = true;
    "privacy.clearHistory.historyFormDataAndDownloads" = true;
    "privacy.cpd.cookies" = false;
    "privacy.cpd.sessions" = true;
    "privacy.cpd.offlineApps" = false;
    "privacy.clearHistory.cookiesAndStorage" = false;
    "privacy.sanitize.timeSpan" = 0;

    # FPP (Fingerprinting Protection)

    # RFP (Resist Fingerprinting)
    "privacy.resistFingerprinting" = true;
    "privacy.window.maxInnerWidth" = 1600;
    "privacy.window.maxInnerHeight" = 900;
    "privacy.resistFingerprinting.block_mozAddonManager" = true;
    "privacy.resistFingerprinting.letterboxing" = true;
    "privacy.spoof_english" = 1;
    "browser.display.use_system_colors" = false;
    "widget.non-native-theme.enabled" = true;
    "browser.link.open_newwindow" = 3; # 1=most recent window or tab, 2=new window, 3=new tab
    "browser.link.open_newwindow.restriction" = 0;
    "webgl.disabled" = true;

    # OPTIONAL OPSEC

    # OPTIONAL HARDENING

    # DON'T TOUCH
    "extensions.blocklist.enabled" = true;
    "network.http.referer.spoofSource" = false;
    "security.dialog_enable_delay" = 1000;
    "privacy.firstparty.isolate" = false;
    "extensions.webcompat.enable_shims" = true;
    "security.tls.version.enable-deprecated" = false;
    "extensions.webcompat-reporter.enabled" = true;
    "extensions.quarantineDomains.enabled" = true;
  };
}
