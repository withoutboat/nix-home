{ config, lib, pkgs, ... }:

let
  projectsFile =
    if config ? sops && config.sops.secrets ? "projects.yml"
    then config.sops.secrets."projects.yml".path
    else ../secrets/projects.yml;
in
{
  sops.secrets."projects.yml" = {
    sopsFile = ../secrets/projects.yml;
  };

  home.activation.cloneProjects = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROJECTS_FILE="${projectsFile}"
    if [ ! -f "$PROJECTS_FILE" ] && [ -f "${../secrets/projects.yml}" ]; then
      PROJECTS_FILE="${../secrets/projects.yml}"
    fi

    if [ -f "$PROJECTS_FILE" ]; then
      ${pkgs.python3.withPackages (ps: [ ps.pyyaml ])}/bin/python3 -c '
import os, sys, yaml, subprocess
from pathlib import Path

projects_file = sys.argv[1]
with open(projects_file) as f:
    items = yaml.safe_load(f) or []

home = Path.home()

for item in items:
    if isinstance(item, dict):
        for proj, repos in item.items():
            proj_dir = home / proj
            proj_dir.mkdir(parents=True, exist_ok=True)
            for repo in (repos or []):
                name = repo.rstrip("/").rsplit("/", 1)[-1].rsplit(":", 1)[-1].removesuffix(".git")
                target = proj_dir / name
                if not target.exists():
                    subprocess.run(["${pkgs.git}/bin/git", "clone", repo, str(target)])
    elif isinstance(item, list) and len(item) >= 2:
        proj = item[0]
        repos = item[1] if isinstance(item[1], list) else item[1:]
        proj_dir = home / proj
        proj_dir.mkdir(parents=True, exist_ok=True)
        for repo in repos:
            name = repo.rstrip("/").rsplit("/", 1)[-1].rsplit(":", 1)[-1].removesuffix(".git")
            target = proj_dir / name
            if not target.exists():
                subprocess.run(["${pkgs.git}/bin/git", "clone", repo, str(target)])
' "$PROJECTS_FILE"
    fi
  '';
}
