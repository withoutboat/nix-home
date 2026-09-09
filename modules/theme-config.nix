{ lib, ... }:

{
  options = {
    lightTheme = lib.mkOption {
      type = lib.types.str;
      default = "default_light";
      description = "Selected light theme name (e.g. solarized_light, default_light)";
    };

    darkTheme = lib.mkOption {
      type = lib.types.str;
      default = "default_dark";
      description = "Selected dark theme name (e.g. default_dark, solarized_dark, tokyo_night_dark)";
    };
  };
}
