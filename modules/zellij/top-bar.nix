{ config, colors }:
''
plugin location="file:${config.xdg.configHome}/zellij/plugins/zjstatus.wasm" {
    format_left   "{tabs}"
    format_right  "#[fg=${colors.base0D},bg=${colors.base00}]#[bg=${colors.base0D},fg=${colors.base00},bold]󰓩 #[bg=${colors.base02},fg=${colors.base05},bold] {session} #[fg=${colors.base02},bg=${colors.base00}]"
    format_space  "#[bg=${colors.base00}]"
    format_hide_on_overlength "true"
    format_precedence "lrc"

    border_enabled  "false"
    hide_frame_for_single_pane "true"

    tab_normal              "#[fg=${colors.base01},bg=${colors.base00}]#[bg=${colors.base01},fg=${colors.base04}]{index} #[bg=${colors.base01},fg=${colors.base05}]{name}{floating_indicator}{fullscreen_indicator}{sync_indicator}#[fg=${colors.base01},bg=${colors.base00}]"
    tab_active              "#[fg=${colors.base0D},bg=${colors.base00}]#[bg=${colors.base0D},fg=${colors.base00},bold]{index} #[bg=${colors.base02},fg=${colors.base05},bold] {name}{floating_indicator}{fullscreen_indicator}{sync_indicator}#[fg=${colors.base02},bg=${colors.base00}]"
    tab_separator           "#[bg=${colors.base00}] "

    tab_sync_indicator       " 󰓦 "
    tab_fullscreen_indicator " 󰊓 "
    tab_floating_indicator   " 󰹙 "
}
''
