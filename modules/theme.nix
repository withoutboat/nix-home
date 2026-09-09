{ config, lib, pkgs, ... }:

let
  themes = {
    solarized_light = {
      polarity = "light";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
      image = pkgs.fetchurl {
        name = "catppuccin-latte-waves.jpg";
        url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Light%206016x6016.jpg";
        sha256 = "6ab30f280e6c09a7e2df0df288c01b0f8a5ac1a70f3f65767a776963c9ced8ed";
      };
    };

    solarized_dark = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
      image = pkgs.fetchurl {
        name = "catppuccin-mocha-waves.jpg";
        url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Dark%206016x6016.jpg";
        sha256 = "1a8e42ab67483980c79674e6b614990630ec4d176691e94e25ae5e6ff2c45d88";
      };
    };

    tokyo_night = {
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      image = pkgs.fetchurl {
        name = "catppuccin-mocha-waves.jpg";
        url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Dark%206016x6016.jpg";
        sha256 = "1a8e42ab67483980c79674e6b614990630ec4d176691e94e25ae5e6ff2c45d88";
      };
    };
  };

  darkThemeName = config.spec.darkTheme or null;
  lightThemeName = config.spec.lightTheme or null;

  darkTheme = if darkThemeName != null then themes.${darkThemeName} or null else null;
  lightTheme = if lightThemeName != null then themes.${lightThemeName} or null else null;
in
{
  stylix = lib.mkIf (darkTheme != null) {
    polarity = darkTheme.polarity;
    base16Scheme = darkTheme.base16Scheme;
    image = darkTheme.image;
  };

  specialisation.light.configuration = lib.mkIf (lightTheme != null) {
    stylix = {
      polarity = lib.mkForce lightTheme.polarity;
      base16Scheme = lib.mkForce lightTheme.base16Scheme;
      image = lib.mkForce lightTheme.image;
    };
  };
}
