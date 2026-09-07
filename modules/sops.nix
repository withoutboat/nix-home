{ config, lib, pkgs, ... }:
{
  home.packages = [
    pkgs.sops
    pkgs.age
    pkgs.age-plugin-yubikey
  ];

  xdg.configFile."sops/age/keys.txt".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-core/secrets/yubikey-identity.txt";

  sops.age = {
    keyFile = lib.mkDefault "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    plugins = [ pkgs.age-plugin-yubikey ];
  };
}
