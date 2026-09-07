{ config, lib, pkgs, ... }:

let
  rawProjectsFile = ../secrets/projects.yml;
  hasProjectsFile = builtins.pathExists rawProjectsFile;
  isEncrypted = hasProjectsFile && (
    let content = builtins.readFile rawProjectsFile;
    in lib.hasInfix "sops:" content || lib.hasInfix "ENC[" content
  );
  projectsFile =
    if isEncrypted && config ? sops && config.sops.secrets ? "projects.yml"
    then config.sops.secrets."projects.yml".path
    else rawProjectsFile;
in
{
  sops = lib.mkIf isEncrypted {
    secrets."projects.yml" = {
      sopsFile = rawProjectsFile;
      format = "binary";
    };
  };

  home.activation.cloneProjects = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROJECTS_FILE="${projectsFile}"
    if [ ! -f "$PROJECTS_FILE" ] && [ -f "${rawProjectsFile}" ]; then
      PROJECTS_FILE="${rawProjectsFile}"
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
