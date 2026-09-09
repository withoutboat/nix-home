{ config, lib, pkgs, username ? null, ... }:

let
  themeLib = import ../lib/themes.nix;

  effectiveUsername =
    if username != null && username != "" then
      username
    else if config ? home && config.home ? username && config.home.username != null && config.home.username != "" then
      config.home.username
    else
      "";

  userConfig = themeLib.getUserConfig effectiveUsername;

  selectedDark =
    if config ? darkTheme && config.darkTheme != "default_dark" then
      config.darkTheme
    else
      userConfig.darkTheme;

  selectedLight =
    if config ? lightTheme && config.lightTheme != "default_light" then
      config.lightTheme
    else
      userConfig.lightTheme;

  darkTheme = themeLib.resolveTheme pkgs selectedDark;
  lightTheme = themeLib.resolveTheme pkgs selectedLight;
in
{
  stylix = {
    enable = lib.mkDefault true;
    polarity = darkTheme.polarity;
    base16Scheme = darkTheme.base16Scheme;
    image = darkTheme.image;
  };

  specialisation.light.configuration = {
    stylix = {
      polarity = lib.mkForce lightTheme.polarity;
      base16Scheme = lib.mkForce lightTheme.base16Scheme;
      image = lib.mkForce lightTheme.image;
    };
  };
}
