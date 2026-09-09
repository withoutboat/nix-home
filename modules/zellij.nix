{ config, lib, options, pkgs, ... }:

let
  hasStylix = options ? stylix && config ? lib.stylix && config.lib.stylix ? colors;

  colors = if hasStylix then
    config.lib.stylix.colors.withHashtag
  else {
    base00 = "#1e1e2e";
    base01 = "#181825";
    base02 = "#313244";
    base03 = "#45475a";
    base04 = "#585b70";
    base05 = "#cdd6f4";
    base06 = "#f5e0dc";
    base07 = "#b4befe";
    base08 = "#f38ba8";
    base09 = "#fab387";
    base0A = "#f9e2af";
    base0B = "#a6e3a1";
    base0C = "#94e2d5";
    base0D = "#89b4fa";
    base0E = "#cba6f7";
    base0F = "#f2cdcd";
  };

  zjstatusWasm = pkgs.fetchurl {
    name = "zjstatus.wasm";
    url = "https://github.com/dj95/zjstatus/releases/download/v0.25.0/zjstatus.wasm";
    hash = "sha256-KCzqshnlbhkIyfrDOQckH+bD4e99hfqrPl9DjO+HuP4=";
  };
in
{
  imports = [
    ./scripts.nix
  ];

  config = lib.mkMerge [
    {
      xdg.configFile."zellij/plugins/zjstatus.wasm".source = zjstatusWasm;

      programs.zellij = {
        enable = lib.mkDefault true;
        enableZshIntegration = lib.mkDefault true;
        settings = {
          default_shell = "nu";
          default_layout = "default";
        };
        layouts.default = ''
          layout {
              default_tab_template {
                  children
                  pane size=1 borderless=true {
                      plugin location="file:${config.xdg.configHome}/zellij/plugins/zjstatus.wasm" {
                          format_left   "{mode}"
                          format_center "{tabs}"
                          format_right  "#[bg=${colors.base02},fg=${colors.base0D},bold]  {session} "
                          format_space  "#[bg=${colors.base01}]"
                          format_hide_on_overlength "true"
                          format_precedence "lrc"

                          border_enabled  "false"
                          hide_frame_for_single_pane "true"

                          mode_normal        "#[bg=${colors.base0D},fg=${colors.base00},bold] NORMAL #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]^p #[fg=${colors.base05}]pane #[fg=${colors.base0A},bold]^t #[fg=${colors.base05}]tab #[fg=${colors.base0A},bold]^s #[fg=${colors.base05}]scroll #[fg=${colors.base0A},bold]^o #[fg=${colors.base05}]session #[fg=${colors.base09},bold]^f #[fg=${colors.base09}]sessionizer #[fg=${colors.base0A},bold]^q #[fg=${colors.base05}]quit "
                          mode_locked        "#[bg=${colors.base08},fg=${colors.base00},bold] LOCKED #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]^g #[fg=${colors.base05}]unlock "
                          mode_pane          "#[bg=${colors.base0B},fg=${colors.base00},bold] PANE #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]h/j/k/l #[fg=${colors.base05}]move #[fg=${colors.base0A},bold]n #[fg=${colors.base05}]new #[fg=${colors.base0A},bold]x #[fg=${colors.base05}]close #[fg=${colors.base0A},bold]f #[fg=${colors.base05}]fullscreen #[fg=${colors.base0A},bold]w #[fg=${colors.base05}]floating "
                          mode_tab           "#[bg=${colors.base0D},fg=${colors.base00},bold] TAB #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]h/l #[fg=${colors.base05}]move #[fg=${colors.base0A},bold]n #[fg=${colors.base05}]new #[fg=${colors.base0A},bold]x #[fg=${colors.base05}]close #[fg=${colors.base0A},bold]r #[fg=${colors.base05}]rename #[fg=${colors.base0A},bold]s #[fg=${colors.base05}]sync "
                          mode_scroll        "#[bg=${colors.base0C},fg=${colors.base00},bold] SCROLL #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]j/k #[fg=${colors.base05}]scroll #[fg=${colors.base0A},bold]d/u #[fg=${colors.base05}]half-page #[fg=${colors.base09},bold]e #[fg=${colors.base09}]neovim #[fg=${colors.base0A},bold]s #[fg=${colors.base05}]search "
                          mode_enter_search  "#[bg=${colors.base0E},fg=${colors.base00},bold] SEARCH #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base05}]enter search query "
                          mode_search        "#[bg=${colors.base0E},fg=${colors.base00},bold] SEARCH #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]n/p #[fg=${colors.base05}]next/prev #[fg=${colors.base0A},bold]c #[fg=${colors.base05}]case #[fg=${colors.base0A},bold]w #[fg=${colors.base05}]wrap "
                          mode_session       "#[bg=${colors.base09},fg=${colors.base00},bold] SESSION #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]d #[fg=${colors.base05}]detach #[fg=${colors.base0A},bold]w #[fg=${colors.base05}]manager #[fg=${colors.base09},bold]f/s #[fg=${colors.base09}]sessionizer #[fg=${colors.base0A},bold]q #[fg=${colors.base05}]quit "
                          mode_resize        "#[bg=${colors.base0A},fg=${colors.base00},bold] RESIZE #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]h/j/k/l #[fg=${colors.base05}]resize #[fg=${colors.base0A},bold]+/- #[fg=${colors.base05}]increase/decrease "
                          mode_move          "#[bg=${colors.base0A},fg=${colors.base00},bold] MOVE #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]h/j/k/l #[fg=${colors.base05}]move "
                          mode_tmux          "#[bg=${colors.base0E},fg=${colors.base00},bold] TMUX #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base09},bold]f #[fg=${colors.base09}]sessionizer #[fg=${colors.base0A},bold]d #[fg=${colors.base05}]detach "

                          tab_normal              "#[bg=${colors.base01},fg=${colors.base04}] {index} {name} "
                          tab_active              "#[bg=${colors.base02},fg=${colors.base05},bold] {index} {name} "
                          tab_sync_indicator      "󰓦 "
                          tab_fullscreen_indicator "󰊓 "
                          tab_floating_indicator   "󰹙 "
                      }
                  }
              }
          }
        '';
        extraConfig = ''
          keybinds {
              normal {
                  bind "Ctrl f" {
                      Run "zellij-sessionizer" {
                          floating true
                          close_on_exit true
                          x "20%"
                          y "20%"
                          width "60%"
                          height "60%"
                      }
                  }
              }
              session {
                  bind "f" "s" "Ctrl f" {
                      Run "zellij-sessionizer" {
                          floating true
                          close_on_exit true
                          x "20%"
                          y "20%"
                          width "60%"
                          height "60%"
                      }
                      SwitchToMode "Normal"
                  }
              }
              tmux {
                  bind "f" {
                      Run "zellij-sessionizer" {
                          floating true
                          close_on_exit true
                          x "20%"
                          y "20%"
                          width "60%"
                          height "60%"
                      }
                      SwitchToMode "Normal"
                  }
              }
              shared_except "locked" {
                  bind "Alt s" {
                      LaunchOrFocusPlugin "session-manager" {
                          floating true
                          move_to_focused_tab true
                      }
                  }
                  bind "Alt f" {
                      Run "zellij-sessionizer" {
                          floating true
                          close_on_exit true
                          x "20%"
                          y "20%"
                          width "60%"
                          height "60%"
                      }
                  }
              }
          }
        '';
      };

      home.shellAliases = {
        zj = "zellij";
        zs = "zellij-sessionizer";
      };
    }
    (lib.optionalAttrs (options ? stylix) {
      stylix.targets.zellij.enable = lib.mkDefault true;
      programs.zellij.settings.theme = lib.mkDefault "default";
      programs.zellij.themes.stylix.themes.default = with colors; {
        fg = base05;
        bg = base00;
        black = base01;
        red = base08;
        green = base0B;
        yellow = base0A;
        blue = base0D;
        magenta = base0E;
        cyan = base0C;
        white = base06;
        orange = base09;
      };
    })
  ];
}
