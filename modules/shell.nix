{ lib, options, pkgs, ... }:

let
  vitaly = pkgs.stdenv.mkDerivation rec {
    pname = "vitaly";
    version = "0.1.32";

    src =
      let
        system = pkgs.stdenv.hostPlatform.system;
        sources = {
          x86_64-linux = {
            url = "https://github.com/bskaplou/vitaly/releases/download/v${version}/vitaly-x86_64-unknown-linux-gnu.tar.xz";
            hash = "sha256-SVk6DMpKbYISvygUeQLXW6WcMmrrshEKRM6/Ht9L2/8=";
          };
          aarch64-linux = {
            url = "https://github.com/bskaplou/vitaly/releases/download/v${version}/vitaly-aarch64-unknown-linux-gnu.tar.xz";
            hash = "sha256-heXP+928biVReOx9jUI9CtPlW7wnaDszJKELIbXNNv4=";
          };
          x86_64-darwin = {
            url = "https://github.com/bskaplou/vitaly/releases/download/v${version}/vitaly-x86_64-apple-darwin.tar.xz";
            hash = "sha256-59Il9YHlXCB87ZIRmOoc4nSfNkrCWLhr4Hoe1mPBBkI=";
          };
          aarch64-darwin = {
            url = "https://github.com/bskaplou/vitaly/releases/download/v${version}/vitaly-aarch64-apple-darwin.tar.xz";
            hash = "sha256-FVOR1oq6spjN4wnTLs9s2R77dD2zWAMpIjU7G2n4ZJU=";
          };
        };
        selected = sources.${system} or (throw "vitaly: unsupported system ${system}");
      in
      pkgs.fetchurl {
        inherit (selected) url hash;
      };

    sourceRoot = ".";

    nativeBuildInputs = lib.optionals pkgs.stdenv.isLinux [
      pkgs.autoPatchelfHook
    ];

    buildInputs = lib.optionals pkgs.stdenv.isLinux [
      pkgs.udev
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      find . -name vitaly -type f -exec cp {} $out/bin/vitaly \;
      chmod 755 $out/bin/vitaly
      runHook postInstall
    '';

    meta = with lib; {
      description = "VIA/Vial API client and CLI tool for keyboard configuration";
      homepage = "https://github.com/bskaplou/vitaly";
      license = licenses.mit;
      mainProgram = "vitaly";
      platforms = platforms.unix;
    };
  };
in
lib.mkMerge [
  {
    home.packages = [
      pkgs.usbutils
      vitaly
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
