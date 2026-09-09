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

  zjstatusPlugin = ''
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
        mode_pane          "#[bg=${colors.base0B},fg=${colors.base00},bold] PANE #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]h/j/k/l #[fg=${colors.base05}]move #[fg=${colors.base0A},bold]n/d/r #[fg=${colors.base05}]new/down/right #[fg=${colors.base0A},bold]x #[fg=${colors.base05}]close #[fg=${colors.base0A},bold]f #[fg=${colors.base05}]fullscreen #[fg=${colors.base0A},bold]w #[fg=${colors.base05}]floating #[fg=${colors.base0A},bold]c #[fg=${colors.base05}]rename "
        mode_tab           "#[bg=${colors.base0D},fg=${colors.base00},bold] TAB #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]h/l #[fg=${colors.base05}]move #[fg=${colors.base0A},bold]1..9 #[fg=${colors.base05}]go #[fg=${colors.base0A},bold]n #[fg=${colors.base05}]new #[fg=${colors.base0A},bold]x #[fg=${colors.base05}]close #[fg=${colors.base0A},bold]r #[fg=${colors.base05}]rename #[fg=${colors.base0A},bold]s #[fg=${colors.base05}]sync "
        mode_scroll        "#[bg=${colors.base0C},fg=${colors.base00},bold] SCROLL #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]j/k #[fg=${colors.base05}]scroll #[fg=${colors.base0A},bold]d/u #[fg=${colors.base05}]half-page #[fg=${colors.base09},bold]e #[fg=${colors.base09}]neovim #[fg=${colors.base0A},bold]/ or s #[fg=${colors.base05}]search #[fg=${colors.base0A},bold]q #[fg=${colors.base05}]exit "
        mode_enter_search  "#[bg=${colors.base0E},fg=${colors.base00},bold] SEARCH #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base05}]enter search query "
        mode_search        "#[bg=${colors.base0E},fg=${colors.base00},bold] SEARCH #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]n/p #[fg=${colors.base05}]next/prev #[fg=${colors.base0A},bold]c #[fg=${colors.base05}]case #[fg=${colors.base0A},bold]w #[fg=${colors.base05}]wrap #[fg=${colors.base0A},bold]q #[fg=${colors.base05}]exit "
        mode_session       "#[bg=${colors.base09},fg=${colors.base00},bold] SESSION #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]d #[fg=${colors.base05}]detach #[fg=${colors.base0A},bold]w #[fg=${colors.base05}]manager #[fg=${colors.base09},bold]f/s #[fg=${colors.base09}]sessionizer #[fg=${colors.base0A},bold]q #[fg=${colors.base05}]quit "
        mode_resize        "#[bg=${colors.base0A},fg=${colors.base00},bold] RESIZE #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]h/j/k/l #[fg=${colors.base05}]resize #[fg=${colors.base0A},bold]+/- #[fg=${colors.base05}]increase/decrease "
        mode_move          "#[bg=${colors.base0A},fg=${colors.base00},bold] MOVE #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base0A},bold]h/j/k/l #[fg=${colors.base05}]move "
        mode_tmux          "#[bg=${colors.base0E},fg=${colors.base00},bold] TMUX #[bg=${colors.base01},fg=${colors.base05}] #[fg=${colors.base09},bold]f #[fg=${colors.base09}]sessionizer #[fg=${colors.base0A},bold][ #[fg=${colors.base05}]scroll #[fg=${colors.base0A},bold]\"/% #[fg=${colors.base05}]split #[fg=${colors.base0A},bold]z #[fg=${colors.base05}]zoom #[fg=${colors.base0A},bold]d #[fg=${colors.base05}]detach "

        tab_normal              "#[bg=${colors.base01},fg=${colors.base04}] {index} {name} "
        tab_active              "#[bg=${colors.base02},fg=${colors.base05},bold] {index} {name} "
        tab_sync_indicator      "󰓦 "
        tab_fullscreen_indicator "󰊓 "
        tab_floating_indicator   "󰹙 "
    }
  '';

  swapLayouts = ''
    swap_tiled_layout name="vertical" {
        tab {
            pane split_direction="vertical" {
                children
            }
        }
    }
    swap_tiled_layout name="horizontal" {
        tab {
            pane split_direction="horizontal" {
                children
            }
        }
    }
    swap_tiled_layout name="stacked" {
        tab {
            pane stacked=true {
                children
            }
        }
    }
    swap_floating_layout name="staggered" {
        floating_panes
    }
    swap_floating_layout name="enlarged" {
        floating_panes max_panes=10 {
            pane { x "5%"; y 1; width "90%"; height "90%"; }
            pane { x "5%"; y 2; width "90%"; height "90%"; }
            pane { x "5%"; y 3; width "90%"; height "90%"; }
            pane { x "5%"; y 4; width "90%"; height "90%"; }
            pane { x "5%"; y 5; width "90%"; height "90%"; }
            pane { x "5%"; y 6; width "90%"; height "90%"; }
            pane { x "5%"; y 7; width "90%"; height "90%"; }
            pane { x "5%"; y 8; width "90%"; height "90%"; }
            pane { x "5%"; y 9; width "90%"; height "90%"; }
            pane focus=true { x 10; y 10; width "90%"; height "90%"; }
        }
    }
    swap_floating_layout name="spread" {
        floating_panes max_panes=1 {
            pane { y "50%"; x "50%"; }
        }
        floating_panes max_panes=2 {
            pane { x "1%"; y "25%"; width "45%"; }
            pane { x "50%"; y "25%"; width "45%"; }
        }
        floating_panes max_panes=3 {
            pane focus=true { y "55%"; width "45%"; height "45%"; }
            pane { x "1%"; y "1%"; width "45%"; }
            pane { x "50%"; y "1%"; width "45%"; }
        }
        floating_panes max_panes=4 {
            pane { x "1%"; y "55%"; width "45%"; height "45%"; }
            pane focus=true { x "50%"; y "55%"; width "45%"; height "45%"; }
            pane { x "1%"; y "1%"; width "45%"; }
            pane { x "50%"; y "1%"; width "45%"; }
        }
    }
  '';
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
          scrollback_editor = "nvim";
          scroll_buffer_size = 10000;
          copy_on_select = true;
        };
        layouts = {
          default = ''
            layout {
                default_tab_template {
                    children
                    pane size=1 borderless=true {
                        ${zjstatusPlugin}
                    }
                }
                ${swapLayouts}
            }
          '';
          compact = ''
            layout {
                default_tab_template {
                    children
                    pane size=1 borderless=true {
                        plugin location="file:${config.xdg.configHome}/zellij/plugins/zjstatus.wasm" {
                            format_left   "{mode} {tabs}"
                            format_right  "#[bg=${colors.base02},fg=${colors.base0D},bold]  {session} "
                            format_space  "#[bg=${colors.base01}]"
                            format_hide_on_overlength "true"
                            format_precedence "lrc"
                            border_enabled "false"
                            hide_frame_for_single_pane "true"

                            mode_normal   "#[bg=${colors.base0D},fg=${colors.base00},bold] NORMAL "
                            mode_locked   "#[bg=${colors.base08},fg=${colors.base00},bold] LOCKED "
                            mode_pane     "#[bg=${colors.base0B},fg=${colors.base00},bold] PANE "
                            mode_tab      "#[bg=${colors.base0D},fg=${colors.base00},bold] TAB "
                            mode_scroll   "#[bg=${colors.base0C},fg=${colors.base00},bold] SCROLL "
                            mode_session  "#[bg=${colors.base09},fg=${colors.base00},bold] SESSION "
                            mode_search   "#[bg=${colors.base0E},fg=${colors.base00},bold] SEARCH "

                            tab_normal    "#[bg=${colors.base01},fg=${colors.base04}] {index} {name} "
                            tab_active    "#[bg=${colors.base02},fg=${colors.base05},bold] {index} {name} "
                        }
                    }
                }
                ${swapLayouts}
            }
          '';
          dev = ''
            layout {
                default_tab_template {
                    children
                    pane size=1 borderless=true {
                        ${zjstatusPlugin}
                    }
                }
                tab name="dev" focus=true {
                    pane split_direction="vertical" {
                        pane size="70%" name="editor"
                        pane size="30%" split_direction="horizontal" {
                            pane name="terminal"
                            pane name="secondary"
                        }
                    }
                }
                ${swapLayouts}
            }
          '';
        };
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
              scroll {
                  bind "e" { EditScrollback; SwitchToMode "Normal"; }
                  bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
                  bind "G" { ScrollToBottom; }
                  bind "q" { ScrollToBottom; SwitchToMode "Normal"; }
              }
              search {
                  bind "q" { ScrollToBottom; SwitchToMode "Normal"; }
              }
              tab {
                  bind "1" { GoToTab 1; SwitchToMode "Normal"; }
                  bind "2" { GoToTab 2; SwitchToMode "Normal"; }
                  bind "3" { GoToTab 3; SwitchToMode "Normal"; }
                  bind "4" { GoToTab 4; SwitchToMode "Normal"; }
                  bind "5" { GoToTab 5; SwitchToMode "Normal"; }
                  bind "6" { GoToTab 6; SwitchToMode "Normal"; }
                  bind "7" { GoToTab 7; SwitchToMode "Normal"; }
                  bind "8" { GoToTab 8; SwitchToMode "Normal"; }
                  bind "9" { GoToTab 9; SwitchToMode "Normal"; }
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
                  bind "Alt t" { NewTab; }
                  bind "Alt 1" { GoToTab 1; }
                  bind "Alt 2" { GoToTab 2; }
                  bind "Alt 3" { GoToTab 3; }
                  bind "Alt 4" { GoToTab 4; }
                  bind "Alt 5" { GoToTab 5; }
                  bind "Alt 6" { GoToTab 6; }
                  bind "Alt 7" { GoToTab 7; }
                  bind "Alt 8" { GoToTab 8; }
                  bind "Alt 9" { GoToTab 9; }

                  bind "Alt h" { MoveFocusOrTab "Left"; }
                  bind "Alt l" { MoveFocusOrTab "Right"; }
                  bind "Alt j" { MoveFocus "Down"; }
                  bind "Alt k" { MoveFocus "Up"; }

                  bind "Alt d" { NewPane "Down"; }
                  bind "Alt r" { NewPane "Right"; }
                  bind "Alt n" { NewPane; }
                  bind "Alt x" { CloseFocus; }
                  bind "Alt w" { ToggleFloatingPanes; }
                  bind "Alt z" { ToggleFocusFullscreen; }
                  bind "Alt =" "Alt +" { Resize "Increase"; }
                  bind "Alt -" { Resize "Decrease"; }
                  bind "Alt [" { PreviousSwapLayout; }
                  bind "Alt ]" { NextSwapLayout; }
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
    })
  ];
}

