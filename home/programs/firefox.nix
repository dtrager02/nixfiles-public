{
  config,
  pkgs,
  inputs,
  ...
}:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs = {
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          DisableTelemetry = true;
 
          Preferences = {
            "browser.contentblocking.category" = {
              Value = "strict";
              Status = "locked";
            };
            "extensions.pocket.enabled" = lock-false;
            "extensions.screenshots.disabled" = lock-true;
            # add global preferences here...
          };
        };
      };

      profiles = {
        profile_0 = {
          # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
          id = 0; # 0 is the default profile; see also option "isDefault"
          name = "profile_0"; # name as listed in about:profiles
          isDefault = true; # can be omitted; true if profile ID is 0
          settings = {
            # specify profile-specific preferences here; check about:config for options
            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.startup.homepage" = "https://google.com";

            "privacy.trackingprotection.enabled" = true;
            "privacy.resistFingerprinting" = true;

            # ---- FIREFOX SYNC CONFIGURATION ----
            # Enable sync for various data types
            # Note: You must log in to Firefox Sync manually once through Firefox UI
            # After initial login, these settings will persist across home-manager rebuilds
            "services.sync.engine.bookmarks" = true;
            "services.sync.engine.history" = true;
            "services.sync.engine.passwords" = true;
            "services.sync.engine.prefs" = true;
            "services.sync.engine.tabs" = true;
            "services.sync.engine.addons" = true;
            "services.sync.autoconnect" = true;

            # add preferences for profile_0 here...
          };

          extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            darkreader
            istilldontcareaboutcookies
            privacy-badger
            refined-github
            sponsorblock
            ublock-origin
            tabliss
            unpaywall
            clearurls
          ];

        };
        profile_1 = {
          id = 1;
          name = "profile_1";
          isDefault = false;
          settings = {
            "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
            "browser.startup.homepage" = "https://ecosia.org";
            # add preferences for profile_1 here...
          };
        };
        # add profiles here...
      };
    };
  };
}
