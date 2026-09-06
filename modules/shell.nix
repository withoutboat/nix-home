{ lib, ... }:

{
  programs.zsh = {
    enable = lib.mkDefault true;
    enableCompletion = lib.mkDefault true;
    autosuggestion.enable = lib.mkDefault true;
    syntaxHighlighting.enable = lib.mkDefault true;
  };

  programs.nushell = {
    enable = lib.mkDefault true;
  };

  programs.starship = {
    enable = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
    enableNushellIntegration = lib.mkDefault true;
  };
}
