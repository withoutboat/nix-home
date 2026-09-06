{ lib, ... }:

{
  programs.zellij = {
    enable = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
    settings = {
      default_shell = "nu";
    };
  };

  home.shellAliases = {
    zj = "zellij";
  };
}
