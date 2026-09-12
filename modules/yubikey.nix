{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yubikey-manager
    libfido2
    pam_u2f
  ];
}
