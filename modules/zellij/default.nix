{ config, lib, options, pkgs, ... }:

let
  hasStylix = options ? stylix && config ? lib.stylix && config.lib.stylix ? colors;

  colors = if hasStylix then
    config.lib.stylix.colors.withHashtag
  else {
    base00 = "#000000";
    base01 = "#1a1a1a";
    base02 = "#333333";
    base03 = "#4d4d4d";
    base04 = "#666666";
    base05 = "#b3b3b3";
    base06 = "#cccccc";
    base07 = "#ffffff";
    base08 = "#ffffff";
    base09 = "#e6e6e6";
    base0A = "#cccccc";
    base0B = "#b3b3b3";
    base0C = "#999999";
    base0D = "#cccccc";
    base0E = "#b3b3b3";
    base0F = "#808080";
  };

  zjstatusWasm = pkgs.fetchurl {
    name = "zjstatus.wasm";
    url = "https://github.com/dj95/zjstatus/releases/download/v0.25.0/zjstatus.wasm";
    hash = "sha256-KCzqshnlbhkIyfrDOQckH+bD4e99hfqrPl9DjO+HuP4=";
  };

  topBarPlugin = import ./top-bar.nix { inherit config colors; };
  bottomBarPlugin = import ./bottom-bar.nix { inherit config colors; };
  layouts = import ./layouts.nix { inherit topBarPlugin bottomBarPlugin; };
  keybinds = import ./keybinds.nix;
in
{
  imports = [
    ./sessionizer.nix
    ./watchdog.nix
  ];

  config = lib.mkMerge [
    {
      xdg.configFile."zellij/plugins/zjstatus.wasm".source = zjstatusWasm;

      programs.zellij = {
        enable = lib.mkDefault true;
        enableZshIntegration = lib.mkDefault false;
        enableBashIntegration = lib.mkDefault false;
        attachExistingSession = lib.mkDefault true;
        exitShellOnExit = lib.mkDefault true;
        settings = {
          default_shell = "nu";
          default_layout = "default";
          scrollback_editor = "nvim";
          scroll_buffer_size = 10000;
          copy_on_select = true;
          show_startup_tips = false;
          show_release_notes = false;
        };
        inherit layouts;
        extraConfig = keybinds;
      };

      programs.zsh.initContent = lib.mkOrder 200 ''
        if [[ -z "$ZELLIJ" && "$TERM" != "dumb" ]]; then
          default_nix_dir="$HOME/nix"
          if [[ "$PWD" == "$HOME" || "$PWD" == "$default_nix_dir" ]]; then
            if [[ -d "$default_nix_dir" ]]; then
              cd "$default_nix_dir"
            fi
            zellij attach -c nix
          else
            session_name=$(basename "$PWD")
            zellij attach -c "$session_name"
          fi

          exit
        fi
      '';

      programs.bash.initExtra = lib.mkOrder 200 ''
        if [[ -z "$ZELLIJ" && "$TERM" != "dumb" ]]; then
          default_nix_dir="$HOME/nix"
          if [[ "$PWD" == "$HOME" || "$PWD" == "$default_nix_dir" ]]; then
            if [[ -d "$default_nix_dir" ]]; then
              cd "$default_nix_dir"
            fi
            zellij attach -c nix
          else
            session_name=$(basename "$PWD")
            zellij attach -c "$session_name"
          fi

          exit
        fi
      '';

      home.shellAliases = {
        zj = "zellij";
      };

      home.activation.zellijPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        append_permission() {
          local file="$1"
          local path="$2"
          if [ -f "$file" ] && grep -Fq "$path" "$file"; then
            return 0
          fi
          mkdir -p "$(dirname "$file")"
          cat <<EOF >> "$file"
"$path" {
    ReadApplicationState
    ChangeApplicationState
    RunCommands
}
EOF
        }

        grant_to_dirs() {
          local p="$1"
          append_permission "''${XDG_CACHE_HOME:-$HOME/.cache}/zellij/permissions.kdl" "$p"
          if [ -d "$HOME/Library/Caches" ] || [ "$(uname)" = "Darwin" ]; then
            append_permission "$HOME/Library/Caches/org.Zellij-Contributors.Zellij/permissions.kdl" "$p"
          fi
        }

        grant_to_dirs "${config.xdg.configHome}/zellij/plugins/zjstatus.wasm"
        grant_to_dirs "$HOME/.config/zellij/plugins/zjstatus.wasm"
      '';
    }
    (lib.optionalAttrs (options ? stylix) {
      stylix.targets.zellij.enable = lib.mkDefault true;
      programs.zellij.settings.theme = lib.mkDefault "default";
    })
  ];
}
