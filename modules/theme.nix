{ config, lib, options, pkgs, ... }:

let
  wallpapers = import ../wallpapers { inherit pkgs; };

  themes = {
    solarized_light = {
      polarity = "light";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
      image = wallpapers.posters.autumn;
      video = wallpapers.autumn;
    };

    solarized_dark = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
      image = wallpapers.posters.camp;
      video = wallpapers.camp;
    };

    tokyo_night = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      image = wallpapers.posters.camp;
      video = wallpapers.camp;
    };

    tokio_night = tokyo_night;
  };

  darkThemeName = config.spec.darkTheme or null;
  lightThemeName = config.spec.lightTheme or null;

  darkTheme = if darkThemeName != null then themes.${darkThemeName} or null else null;
  lightTheme = if lightThemeName != null then themes.${lightThemeName} or null else null;

  hasVideo = (darkTheme != null && darkTheme ? video) || (lightTheme != null && lightTheme ? video);
in
{
  stylix = lib.mkIf (options ? stylix && darkTheme != null) {
    polarity = darkTheme.polarity;
    base16Scheme = darkTheme.base16Scheme;
    image = darkTheme.image;
    targets.hyprpaper.enable = lib.mkIf hasVideo (lib.mkDefault false);
    targets.swaybg.enable = lib.mkIf hasVideo (lib.mkDefault false);
  };

  specialisation.light.configuration = lib.mkIf (lightTheme != null) {
    stylix = lib.mkIf (options ? stylix) {
      polarity = lib.mkForce lightTheme.polarity;
      base16Scheme = lib.mkForce lightTheme.base16Scheme;
      image = lib.mkForce lightTheme.image;
      targets.hyprpaper.enable = lib.mkIf hasVideo (lib.mkForce false);
      targets.swaybg.enable = lib.mkIf hasVideo (lib.mkForce false);
    };

    systemd.user.services.mpvpaper = lib.mkIf (lightTheme ? video) {
      Service.ExecStart = lib.mkForce "${pkgs.mpvpaper}/bin/mpvpaper -o \"no-audio --loop-playlist\" '*' ${lightTheme.video}";
    };
  };

  home.packages = lib.mkIf hasVideo [
    pkgs.mpvpaper
  ];

  systemd.user.services.mpvpaper = lib.mkIf (darkTheme != null && darkTheme ? video) {
    Unit = {
      Description = "Animated video wallpaper using mpvpaper";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.mpvpaper}/bin/mpvpaper -o \"no-audio --loop-playlist\" '*' ${darkTheme.video}";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
