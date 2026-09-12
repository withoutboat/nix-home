{ lib, options, pkgs, ... }:

lib.mkMerge [
  {
    home.packages = [
      pkgs.usbutils
    ];

    programs.zsh = {
      enable = lib.mkDefault true;
      enableCompletion = lib.mkDefault true;
      autosuggestion.enable = lib.mkDefault true;
      syntaxHighlighting.enable = lib.mkDefault true;
      history = {
        size = 100000;
        save = 100000;
        share = true;
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
      };
      initContent = ''
        bindkey -s '^f' 'zellij-sessionizer\n'

        # Vi mode
        bindkey -v
        export KEYTIMEOUT=1

        # Fix history navigation in vi mode
        bindkey '^[[A' up-line-or-search
        bindkey '^[[B' down-line-or-search
        bindkey -M vicmd 'k' up-line-or-search
        bindkey -M vicmd 'j' down-line-or-search

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
      settings = {
        edit_mode = "vi";
        buffer_editor = "nvim";
        history = {
          file_format = "sqlite";
          max_size = 100000;
          sync_on_enter = true;
          isolation = false;
        };
      };
      extraConfig = ''
        $env.config.keybindings = ($env.config | get -o keybindings | default [] | append [
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

    programs.atuin = {
      enable = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
      settings = {
        auto_sync = false;
        sync_frequency = "1h";
        sync_address = "https://api.atuin.sh";
        search_mode = "fuzzy";
        filter_mode = "global";
        style = "compact";
      };
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
