{ pkgs, ... }:
{
  imports = [ ./profile.nix ];

  home.sessionVariables = {
    # Better touchscreen and touchpad support as well as smooth scrolling
    MOZ_USE_XINPUT2 = "1";
  };

  programs.firefox = {
    enable = true;

    # Force enable pipewireSupport for wayland screenshare
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) { 
      extraPolicies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = false;
        DisableAccounts = false;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/uborigin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Vimium:
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
          };
          # KeePass XC Browser
          "keepassxc-browser@keepassxc.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
            installation_mode = "force_installed";
          };
          # I don't care about cookies
          "jid1-KKzOGWgsW3Ao4Q@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/i-dont-care-about-cookies/latest.xpi";
            installation_mode = "force_installed";
          };
          # Stylus
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/styl-us/latest.xpi";
            installation_mode = "force_installed";
          };
          # Binnen-I begone
          "{b65d7d9a-4ec0-4974-b07f-83e30f6e973f}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/binnen-i-be-gone/latest.xpi";
            installation_mode = "force_installed";
          }; 
          # Catppuccin Mocha Mauve
          "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-mauve-git/latest.xpi";
            installation_mode = "force_installed";
          };
          # Sidebery
          "{3c078156-979c-498b-8990-85f7987dd929}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
            installation_mode = "force_installed";
          };
          # Default (All other extensions)
          "*" = {
            installation_mode = "blocked"; # blocks all addons except the ones specified below
          };
        };
      };
    };
  };

  # home.persistence = {
  #   "/nix/persist/home/skarmux".directories = [ ".mozilla/firefox" ];
  # };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
