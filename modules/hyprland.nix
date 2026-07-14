{ pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
  }; 

  xdg.portal.enable = lib.mkForce false;

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    monitor = ",preferred,auto,1";

    input = {
      kb_layout = "us";
      follow_mouse = 1;
      touchpad.natural_scroll = true;
    };

    general = {
      gaps_in = 4;
      gaps_out = 8;
      border_size = 2;
      layout = "dwindle";
    };

    decoration.rounding = 8;

    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
    };

    exec-once = [
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland"
      "hyprpaper"
      "waybar"
      "mako"
    ];

    bind = [
      "$mod, Q, exec, ghostty"
      "$mod, C, killactive,"
      "$mod, M, exit,"
      "$mod, F, fullscreen,"
      "$mod, V, togglefloating,"
      "$mod, D, exec, wofi --show drun"
      "$mod, P, pseudo,"
      "$mod, J, layoutmsg, togglesplit"
      
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"
      
      "$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"
    ] ++ (
      builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]
      ) 9)
    );
  };
}
