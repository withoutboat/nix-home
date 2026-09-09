{ config, lib, options, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
lib.mkMerge [
  {
    programs.zsh = {
      enable = lib.mkDefault true;
      enableCompletion = lib.mkDefault true;
      autosuggestion.enable = lib.mkDefault true;
      syntaxHighlighting.enable = lib.mkDefault true;
      initExtra = ''
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
    };
  }
  (lib.optionalAttrs (options ? stylix) {
    stylix.targets = {
      nushell.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
    };
  })
  (lib.mkIf (!(options ? stylix && config.stylix.enable)) {
    programs.starship.settings = {
      palette = lib.mkDefault "base16";
      palettes.base16 = with colors; {
        black = base00;
        bright-black = base03;
        white = base05;
        bright-white = base07;
        red = base08;
        orange = base09;
        yellow = base0A;
        green = base0B;
        cyan = base0C;
        blue = base0D;
        magenta = base0E;
        purple = base0E;
        bright-purple = base0E;
        inherit base00 base01 base02 base03 base04 base05 base06 base07 base08 base09;
        base0a = base0A;
        base0b = base0B;
        base0c = base0C;
        base0d = base0D;
        base0e = base0E;
        base0f = base0F;
      };
    };
  })
]
