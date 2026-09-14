{ pkgs, ... }:
let
  theme-set = pkgs.writeShellScriptBin "theme-set" (builtins.readFile ../scripts/theme-set);
  theme-toggle = pkgs.writeShellScriptBin "theme-toggle" (builtins.readFile ../scripts/theme-toggle);
in
{
  home.packages = [
    theme-set
    theme-toggle
  ];

  systemd.user.services = {
    theme-switch-light = {
      Unit = {
        Description = "Switch theme to light mode";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${theme-set}/bin/theme-set light";
      };
    };

    theme-switch-dark = {
      Unit = {
        Description = "Switch theme to dark mode";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${theme-set}/bin/theme-set dark";
      };
    };
  };

  systemd.user.timers = {
    theme-switch-light = {
      Unit = {
        Description = "Timer to switch theme to light mode at 09:00";
      };
      Timer = {
        OnCalendar = "*-*-* 09:00:00";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    theme-switch-dark = {
      Unit = {
        Description = "Timer to switch theme to dark mode at 16:00";
      };
      Timer = {
        OnCalendar = "*-*-* 16:00:00";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
