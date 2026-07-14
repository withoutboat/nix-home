{ pkgs, ... }:

{
  home.packages = [
    pkgs.hyprland
    pkgs.dconf
  ];

  xdg.configFile."hypr/hyprland.conf".text = ''
    $mod = SUPER

    monitor = ,preferred,auto,1

    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
    exec-once = hyprpaper
    exec-once = waybar
    exec-once = mako

    input {
      kb_layout = us
      follow_mouse = 1
      touchpad {
        natural_scroll = yes
      }
    }

    general {
      gaps_in = 4
      gaps_out = 8
      border_size = 2
      layout = dwindle
    }

    decoration {
      rounding = 8
    }

    misc {
      force_default_wallpaper = 0
      disable_hyprland_logo = true
    }

    bind = $mod, Q, exec, ghostty
    bind = $mod, C, killactive,
    bind = $mod, M, exit,
    bind = $mod, F, fullscreen,
    bind = $mod, V, togglefloating,
    bind = $mod, D, exec, wofi --show drun
    bind = $mod, P, pseudo,
    bind = $mod, J, layoutmsg, togglesplit

    bind = $mod, left, movefocus, l
    bind = $mod, right, movefocus, r
    bind = $mod, up, movefocus, u
    bind = $mod, down, movefocus, d

    bind = $mod SHIFT, left, movewindow, l
    bind = $mod SHIFT, right, movewindow, r
    bind = $mod SHIFT, up, movewindow, u
    bind = $mod SHIFT, down, movewindow, d

    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
    bind = $mod SHIFT, 6, movetoworkspace, 6
    bind = $mod SHIFT, 7, movetoworkspace, 7
    bind = $mod SHIFT, 8, movetoworkspace, 8
    bind = $mod SHIFT, 9, movetoworkspace, 9
    bind = $mod SHIFT, 0, movetoworkspace, 10
  '';
}
