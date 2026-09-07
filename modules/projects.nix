{ config, lib, pkgs, ... }:

let
  projectsFile =
    if config ? sops && config.sops.secrets ? "projects.yml"
    then config.sops.secrets."projects.yml".path
    else ../secrets/projects.yml;
in
{
  home.activation.cloneProjects = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROJECTS_FILE="${projectsFile}"
    if [ ! -f "$PROJECTS_FILE" ] && [ -f "${../secrets/projects.yml}" ]; then
      PROJECTS_FILE="${../secrets/projects.yml}"
    fi

    if [ -f "$PROJECTS_FILE" ]; then
      ${pkgs.gawk}/bin/awk '
        /^[[:space:]]*-[[:space:]]*(git@|https?:\/\/)/ {
          sub(/^[[:space:]]*-[[:space:]]*/, "")
          repo = $0
          sub(/\.git$/, "", repo)
          n = split(repo, a, /[:\/]/)
          reponame = a[n]
          if (proj != "") {
            print "CLONE", $0, proj "/" reponame
          }
          next
        }
        /^[[:space:]]*-?[[:space:]]*[a-zA-Z0-9_.-]+:?[[:space:]]*$/ {
          p = $0
          sub(/^[[:space:]]*-?[[:space:]]*/, "", p)
          sub(/:[[:space:]]*$/, "", p)
          if (p != "") {
            proj = p
            print "DIR", proj
          }
        }
      ' "$PROJECTS_FILE" | while read -r action arg1 arg2; do
        if [ "$action" = "DIR" ]; then
          mkdir -p "$HOME/$arg1"
        elif [ "$action" = "CLONE" ]; then
          TARGET="$HOME/$arg2"
          if [ ! -d "$TARGET/.git" ] && [ ! -d "$TARGET" ]; then
            echo "Cloning $arg1 into $TARGET..."
            ${pkgs.git}/bin/git clone "$arg1" "$TARGET" || true
          fi
        fi
      done
    fi
  '';
}
