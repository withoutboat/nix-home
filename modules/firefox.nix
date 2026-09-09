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
          "datareporting.healthreport.uploadEnabled" = false; # disable telemetria 
          "privacy.trackingprotection.enabled" = true;
        };
      };
    };
  }
  (lib.optionalAttrs (options ? stylix) {
    stylix.targets.firefox.profileNames = [ "default" ];
  })
]
