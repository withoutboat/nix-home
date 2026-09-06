{ config, ... }:
{
  xdg.configFile."sops/age/keys.txt".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-core/secrets/yubikey-identity.txt";
}
