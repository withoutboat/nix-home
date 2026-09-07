{ config, lib, pkgs, ... }:

let
  cfg = config.programs.projects;

  projects-sync = pkgs.writeShellScriptBin "projects-sync" ''
    export PATH="${pkgs.lib.makeBinPath [ pkgs.git pkgs.sops pkgs.coreutils (pkgs.python3.withPackages (ps: [ ps.pyyaml ])) ]}:$PATH"
    export DEFAULT_PROJECTS_FALLBACK="${../secrets/projects.yml}"
    exec ${pkgs.python3}/bin/python3 ${../scripts/projects-sync} "$@"
  '';
in
{
  options.programs.projects = {
    enable = lib.mkEnableOption "projects repository synchronization" // {
      default = true;
    };

    dataFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Path to the projects.yml secret file.
        If null, projects-sync searches standard locations:
        - ~/nix-home/secrets/projects.yml
        - ~/personal/nix-home/secrets/projects.yml
        - ~/.dotfiles/secrets/projects.yml
        - or falls back to the bundled secrets/projects.yml.
      '';
    };

    autoSync = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically synchronize repositories during home-manager activation.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      projects-sync
    ];

    home.shellAliases = {
      psync = "projects-sync";
    };

    home.activation.syncProjects = lib.mkIf cfg.autoSync (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Syncing projects..."
      ${if cfg.dataFile != null then ''
        $DRY_RUN_CMD ${projects-sync}/bin/projects-sync --file "${cfg.dataFile}" || true
      '' else ''
        $DRY_RUN_CMD ${projects-sync}/bin/projects-sync || true
      ''}
    '');
  };
}
