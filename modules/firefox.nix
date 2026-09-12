{ pkgs, lib, options, ... }:
lib.mkMerge [
  {
    programs.firefox = {
      enable = true;

      profiles.default = {
        id = 0;
        isDefault = true;
        name = "default";

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
        ];

        settings = {
          "browser.startup.page" = 3; # keep prev sessions
          "browser.aboutConfig.showWarning" = false;
          "datareporting.healthreport.uploadEnabled" = false; # disable telemetry
          "privacy.trackingprotection.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        userChrome = ''
          /* Move toolbars (tabs and navbar) to the bottom of the window */
          #main-window > body {
            display: flex !important;
            flex-direction: column !important;
          }

          #browser,
          #customization-container {
            -moz-box-ordinal-group: 0 !important;
            order: 0 !important;
            flex: 1 1 auto !important;
          }

          .global-notificationbox,
          #tab-notification-deck,
          #notifications-toolbar {
            -moz-box-ordinal-group: 0 !important;
            order: 0 !important;
          }

          #navigator-toolbox,
          #navigator-toolbox-background {
            -moz-box-ordinal-group: 1 !important;
            order: 1 !important;
            overflow: visible !important;
            opacity: 0.8 !important; /* 20% transparency (80% opacity) */
            transition: opacity 0.2s ease-in-out !important;
            border-bottom: none !important;
            border-top: 1px solid var(--chrome-content-separator-color, rgba(0, 0, 0, 0.15)) !important;
          }

          #navigator-toolbox:hover,
          #navigator-toolbox:focus-within {
            opacity: 1 !important;
          }

          #TabsToolbar {
            background: inherit !important;
          }

          /* Hide titlebar buttons and spacers on bottom tab bar */
          #TabsToolbar > :is(.titlebar-buttonbox-container, .titlebar-spacer) {
            display: none !important;
          }

          /* Hide toolbars in fullscreen */
          :root[inFullscreen] #navigator-toolbox {
            display: none !important;
          }

          /* Fix popup panels sizing */
          .panel-viewstack {
            max-height: unset !important;
          }

          /* Open urlbar suggestions popup upwards */
          #urlbar[breakout][breakout-extend] {
            display: flex !important;
            flex-direction: column-reverse !important;
            bottom: 0px !important;
            top: auto !important;
          }

          .urlbarView-body-inner {
            border-top-style: none !important;
          }

          .searchmode-switcher[offscreen] {
            top: 999px !important;
          }

          @media (-moz-platform: linux) {
            #notification-popup[side="top"] {
              margin-top: calc(-2 * var(--panel-padding-block, 8px) - 40px - 32px - 8.5em) !important;
            }
            #permission-popup[side="top"] {
              margin-top: calc(-2 * var(--panel-padding-block, 8px) - 2.5em) !important;
            }
          }
        '';
      };
    };
  }
  (lib.optionalAttrs (options ? stylix) {
    stylix.targets.firefox.profileNames = [ "default" ];
  })
]
