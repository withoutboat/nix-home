{ lib, options, ... }:

lib.mkMerge [
  {
    programs.zsh = {
      enable = lib.mkDefault true;
      enableCompletion = lib.mkDefault true;
      autosuggestion.enable = lib.mkDefault true;
      syntaxHighlighting.enable = lib.mkDefault true;
      initContent = ''
        bindkey -s '^f' 'zellij-sessionizer\n'
      '';
    };

    programs.nushell = {
      enable = lib.mkDefault true;
    };

    programs.starship = {
      enable = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
      settings = {
        command_timeout = 2000;
      };
    };
  }
  (lib.optionalAttrs (options ? stylix) {
    stylix.targets = {
      nushell.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
    };
  })
]
