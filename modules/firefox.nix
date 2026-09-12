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
          /* Move navbar (address bar and buttons) to the bottom of the window */
          :root:not([inFullscreen]) {
            --uc-bottom-toolbar-height: calc(39px + var(--toolbarbutton-padding-outer, var(--toolbarbutton-outer-padding, 2px)));
          }

          :root[uidensity="compact"]:not([inFullscreen]) {
            --uc-bottom-toolbar-height: calc(32px + var(--toolbarbutton-padding-outer, var(--toolbarbutton-outer-padding, 2px)));
          }

          #browser,
          #customization-container {
            margin-bottom: var(--uc-bottom-toolbar-height, 0px) !important;
          }

          #nav-bar {
            position: fixed !important;
            bottom: 0px !important;
            display: -webkit-box !important;
            width: 100% !important;
            z-index: 100 !important;
            opacity: 0.8 !important; /* 20% transparency (80% opacity) */
            transition: opacity 0.2s ease-in-out !important;
          }

          #nav-bar:hover,
          #nav-bar:focus-within {
            opacity: 1 !important;
          }

          #nav-bar-customization-target {
            -webkit-box-flex: 1 !important;
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
