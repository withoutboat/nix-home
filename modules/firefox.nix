{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
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
