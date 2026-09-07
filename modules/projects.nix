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
      ${pkgs.zsh}/bin/zsh -c '
        projects_file="$1"
        current_project=""

        while IFS= read -r line || [[ -n "$line" ]]; do
          trimmed="''${line#"''${line%%[![:space:]]*}"}"
          trimmed="''${trimmed%"''${trimmed##*[![:space:]]}"}"

          [[ -z "$trimmed" || "$trimmed" == \#* ]] && continue

          if [[ "$trimmed" =~ ^-\ +([^[:space:]]+)$ ]]; then
            val="''${match[1]}"
            if [[ "$val" == *@* || "$val" == http* || "$val" == ssh://* || "$val" == *.git ]]; then
              repo="$val"
              repo_name="''${repo##*/}"
              repo_name="''${repo_name##*:}"
              repo_name="''${repo_name%.git}"
              target="$HOME/$current_project/$repo_name"

              if [[ ! -d "$target/.git" && ! -d "$target" ]]; then
                echo "Cloning $repo -> $target"
                ${pkgs.git}/bin/git clone "$repo" "$target" || true
              fi
              continue
            fi
          fi

          if [[ "$trimmed" =~ ^-?\ *([a-zA-Z0-9_.-]+):?$ ]]; then
            current_project="''${match[1]}"
            mkdir -p "$HOME/$current_project"
          fi
        done < "$projects_file"
      ' zsh "$PROJECTS_FILE"
    fi
  '';
}
