rec {
  themes = pkgs: {
    default_dark = {
      name = "default_dark";
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      image = pkgs.fetchurl {
        name = "catppuccin-mocha-waves.jpg";
        url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Dark%206016x6016.jpg";
        sha256 = "1a8e42ab67483980c79674e6b614990630ec4d176691e94e25ae5e6ff2c45d88";
      };
    };

    default_light = {
      name = "default_light";
      polarity = "light";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
      image = pkgs.fetchurl {
        name = "catppuccin-latte-waves.jpg";
        url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Light%206016x6016.jpg";
        sha256 = "6ab30f280e6c09a7e2df0df288c01b0f8a5ac1a70f3f65767a776963c9ced8ed";
      };
    };

    solarized_light = {
      name = "solarized_light";
      polarity = "light";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
      image = pkgs.fetchurl {
        name = "catppuccin-latte-waves.jpg";
        url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Light%206016x6016.jpg";
        sha256 = "6ab30f280e6c09a7e2df0df288c01b0f8a5ac1a70f3f65767a776963c9ced8ed";
      };
    };

    solarized_dark = {
      name = "solarized_dark";
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
      image = pkgs.fetchurl {
        name = "catppuccin-mocha-waves.jpg";
        url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Dark%206016x6016.jpg";
        sha256 = "1a8e42ab67483980c79674e6b614990630ec4d176691e94e25ae5e6ff2c45d88";
      };
    };

    tokyo_night_dark = {
      name = "tokyo_night_dark";
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      image = pkgs.fetchurl {
        name = "catppuccin-mocha-waves.jpg";
        url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Dark%206016x6016.jpg";
        sha256 = "1a8e42ab67483980c79674e6b614990630ec4d176691e94e25ae5e6ff2c45d88";
      };
    };
  };

  normalizeThemeName = name: {
    "solirized_light" = "solarized_light";
    "solorized_light" = "solarized_light";
    "solarized_light" = "solarized_light";
    "solarized-light" = "solarized_light";
    "solirized_dark" = "solarized_dark";
    "solorized_dark" = "solarized_dark";
    "solarized_dark" = "solarized_dark";
    "solarized-dark" = "solarized_dark";
    "tokio_nigth_dark" = "tokyo_night_dark";
    "tokyo_night_dark" = "tokyo_night_dark";
    "tokyo_night" = "tokyo_night_dark";
    "tokyo-night-dark" = "tokyo_night_dark";
    "tokyo-night" = "tokyo_night_dark";
    "catppuccin_mocha" = "default_dark";
    "catppuccin-mocha" = "default_dark";
    "catppuccin_latte" = "default_light";
    "catppuccin-latte" = "default_light";
    "default_dark" = "default_dark";
    "default-dark" = "default_dark";
    "default_light" = "default_light";
    "default-light" = "default_light";
  }.${name} or name;

  getUserConfig = username:
    let
      userConfigFile = ../configs + "/${username}.nix";
      raw = if builtins.pathExists userConfigFile then
        import userConfigFile
      else
        {
          lightTheme = "default_light";
          darkTheme = "default_dark";
        };
      rawConfig = if builtins.isFunction raw then raw { } else raw;
    in
    {
      lightTheme = normalizeThemeName (rawConfig.lightTheme or "default_light");
      darkTheme = normalizeThemeName (rawConfig.darkTheme or "default_dark");
    };

  resolveTheme = pkgs: name:
    let
      normalized = normalizeThemeName name;
      all = themes pkgs;
    in
    all.${normalized} or all.default_dark;
}
