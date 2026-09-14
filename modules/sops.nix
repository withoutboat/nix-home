{ config, lib, pkgs, ... }:

let
  defaultKeyFile =
    if builtins.pathExists "/etc/sops/age/keys.txt"
    then "/etc/sops/age/keys.txt"
    else "${config.home.homeDirectory}/nix-core/secrets/yubikey-identity.txt";
in
{
  home.packages = [
    pkgs.sops
    pkgs.age
    pkgs.age-plugin-yubikey
  ];

  xdg.configFile."sops/age/keys.txt".source =
    config.lib.file.mkOutOfStoreSymlink defaultKeyFile;

  sops.age = {
    keyFile = lib.mkDefault defaultKeyFile;
    plugins = [ pkgs.age-plugin-yubikey ];
  };

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = lib.mkDefault defaultKeyFile;
  };
}

