{ config, lib, username ? null, ... }:

let
  user =
    if username != null && username != "" then
      username
    else if config ? home && config.home ? username && config.home.username != null && config.home.username != "" then
      config.home.username
    else
      "";

  userConfigFile = ../configs + "/${user}.nix";
  hasUserConfig = user != "" && builtins.pathExists userConfigFile;
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
