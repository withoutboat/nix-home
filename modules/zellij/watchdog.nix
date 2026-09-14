{ lib, pkgs, ... }:

let
  watchdogScript = pkgs.writeShellScript "zellij-memory-watchdog" ''
    MAX_RSS_KB=$((2 * 1024 * 1024)) # 2 GB limit for zellij server

    for pid in $(${pkgs.procps}/bin/pgrep -f "zellij.*--server" 2>/dev/null || true); do
      if [ -r "/proc/$pid/status" ]; then
        rss_kb=$(${pkgs.gnugrep}/bin/grep -i '^VmRSS:' "/proc/$pid/status" | ${pkgs.gawk}/bin/awk '{print $2}')
        if [ -n "$rss_kb" ] && [ "$rss_kb" -gt "$MAX_RSS_KB" ]; then
          echo "Zellij server (PID $pid) exceeded 2GB RSS ($rss_kb KB). Terminating to prevent OOM..."
          ${pkgs.coreutils}/bin/kill -9 "$pid" 2>/dev/null || true
        fi
      fi
    done
  '';
in
{
  systemd.user.services.zellij-memory-watchdog = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Watchdog to kill leaking Zellij server processes exceeding 2GB";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${watchdogScript}";
    };
  };

  systemd.user.timers.zellij-memory-watchdog = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "Check Zellij memory usage periodically";
    };
    Timer = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
