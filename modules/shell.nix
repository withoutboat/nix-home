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

        # Vi mode
        bindkey -v
        export KEYTIMEOUT=1

        # Edit current command line in Neovim
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^[e' edit-command-line
        bindkey -M vicmd '^[e' edit-command-line
        bindkey -M vicmd 'v' edit-command-line
      '';
    };

    programs.nushell = {
      enable = lib.mkDefault true;
      extraConfig = ''
        $env.config = ($env.config? | default {})
        $env.config.edit_mode = "vi"
        $env.config.buffer_editor = "nvim"
        $env.config.keybindings = ($env.config | get -i keybindings | default [] | append [
          {
            name: open_editor_alt_e
            modifier: alt
            keycode: char_e
            mode: [emacs, vi_normal, vi_insert]
            event: { send: OpenEditor }
          }
          {
            name: open_editor_v
            modifier: none
            keycode: char_v
            mode: vi_normal
            event: { send: OpenEditor }
          }
        ])
      '';
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
