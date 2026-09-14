args@{ ... }:

if args ? pkgs then
  # Called directly as a Home Manager module: { config, lib, pkgs, nix-bin ? null, inputs ? {}, ... }
  let
    config = args.config;
    lib = args.lib;
    pkgs = args.pkgs;
    inputs = args.inputs or {};
    nix-bin = args.nix-bin or inputs.nix-bin or null;
    system = pkgs.stdenv.hostPlatform.system;
    vialDaemonPkg =
      if nix-bin != null
      then (nix-bin.packages.${system}.vial-daemon or nix-bin.packages.${system}.default or null)
      else pkgs.vial-daemon or null;
  in
  {
    home.packages = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && vialDaemonPkg != null) [
      vialDaemonPkg
    ];

    systemd.user.services.vial-daemon = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && vialDaemonPkg != null) {
      Unit = {
        Description = "Vial keyboard layer tracking daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${vialDaemonPkg}/bin/vial-daemon";
        Restart = "always";
        RestartSec = 3;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  }
else
  # Called as a function with inputs: import ./modules/vial-daemon.nix { inherit nix-bin; }
  { config, lib, pkgs, inputs ? {}, ... }@moduleArgs:
  let
    inputs' = moduleArgs.inputs or {};
    nix-bin' = args.nix-bin or moduleArgs.nix-bin or inputs'.nix-bin or null;
    system = pkgs.stdenv.hostPlatform.system;
    vialDaemonPkg =
      if nix-bin' != null
      then (nix-bin'.packages.${system}.vial-daemon or nix-bin'.packages.${system}.default or null)
      else pkgs.vial-daemon or null;
  in
  {
    home.packages = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && vialDaemonPkg != null) [
      vialDaemonPkg
    ];

    systemd.user.services.vial-daemon = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && vialDaemonPkg != null) {
      Unit = {
        Description = "Vial keyboard layer tracking daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${vialDaemonPkg}/bin/vial-daemon";
        Restart = "always";
        RestartSec = 3;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  }
