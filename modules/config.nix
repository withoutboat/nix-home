{ config, lib, ... }:

let
  userConfigFile = ../configs + "/${config.home.username}.nix";
  hasUserConfig = builtins.pathExists userConfigFile;
  raw = if hasUserConfig then import userConfigFile else { };
  userConfig = if builtins.isFunction raw then raw { inherit config lib; } else raw;
in
{
  options = {
    spec = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.anything;
        options = {
          lightTheme = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Selected light theme name";
          };

          darkTheme = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Selected dark theme name";
          };
        };
      };
      default = { };
      description = "User specification and config from configs/<user>.nix";
    };
  };

  config = lib.mkIf hasUserConfig {
    spec = lib.mkDefault userConfig;
  };
}
