{ config, lib, options, ... }:
{
  xdg.configFile."sops/age/keys.txt".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-core/secrets/yubikey-identity.txt";

  sops = lib.mkIf (options ? sops) {
    age.keyFile = lib.mkDefault "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
