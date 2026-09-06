{ lib, ... }:

{
  programs.nixvim = {
    enable = lib.mkDefault true;
    defaultEditor = lib.mkDefault true;
    viAlias = lib.mkDefault true;
    vimAlias = lib.mkDefault true;
  };

  home.sessionVariables = {
    EDITOR = lib.mkDefault "nvim";
    VISUAL = lib.mkDefault "nvim";
  };

  home.shellAliases = {
    v = "nvim";
    vim = "nvim";
  };
}
