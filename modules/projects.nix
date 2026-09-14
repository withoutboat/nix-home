args@{ ... }:

let
  module = { config, lib, pkgs, inputs ? {}, ... }@moduleArgs:
  let
    inputs' = moduleArgs.inputs or {};
    nix-bin' = args.nix-bin or moduleArgs.nix-bin or inputs'.nix-bin or null;
    system = pkgs.stdenv.hostPlatform.system;
    projectorPkg =
      if nix-bin' != null
      then (nix-bin'.packages.${system}.projector or null)
      else pkgs.projector or null;

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
    home.packages = lib.mkIf (projectorPkg != null) [
      projectorPkg
    ];

    sops = lib.mkIf isEncrypted {
      secrets."projects.yml" = {
        sopsFile = rawProjectsFile;
        format = "yaml";
        key = "";
      };
    };

    home.activation.cloneProjects = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PROJECTS_FILE="${projectsFile}"
      if [ ! -f "$PROJECTS_FILE" ] && [ -f "${rawProjectsFile}" ]; then
        PROJECTS_FILE="${rawProjectsFile}"
      fi

      if [ -f "$PROJECTS_FILE" ]; then
        if ${if projectorPkg != null then "true" else "false"}; then
          echo "Synchronizing projects with projector..."
          export PATH="${pkgs.git}/bin:$PATH"
          ${if projectorPkg != null then "${projectorPkg}/bin/projector" else "true"} "$PROJECTS_FILE" || true
        else
          ${pkgs.zsh}/bin/zsh -c '
            projects_file="$1"
            current_project=""
            in_sops=0
            roots_file="$HOME/.config/projector/roots"
            mkdir -p "$HOME/.config/projector"
            : > "$roots_file"

            while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
              line="''${raw_line%$'\''\r'\''}"

              # Skip empty lines and full comment lines
              [[ "$line" =~ ^[[:space:]]*$ || "$line" =~ ^[[:space:]]*# ]] && continue

              # Top-level key: no leading whitespace, ends with colon (e.g. project_name:)
              if [[ "$line" =~ ^([a-zA-Z0-9_.-]+):[[:space:]]*(#.*)?$ ]]; then
                key="''${match[1]}"
                if [[ "$key" == "sops" ]]; then
                  in_sops=1
                  current_project=""
                else
                  in_sops=0
                  current_project="$key"
                  mkdir -p "$HOME/$current_project"
                  echo "$HOME/$current_project" >> "$roots_file"
                fi
                continue
              fi

              # Skip if within SOPS metadata or if no project is active
              [[ $in_sops -eq 1 || -z "$current_project" ]] && continue

              # Indented lines under the current project are repository entries
              if [[ "$line" =~ ^[[:space:]]+(.*)$ ]]; then
                content="''${match[1]}"
                content="''${content%%[[:space:]]#*}"
                content="''${content#"''${content%%[![:space:]]*}"}"
                content="''${content%"''${content##*[![:space:]]}"}"

                repo=""
                custom_name=""

                if [[ "$content" =~ ^(-[[:space:]]+)?([a-zA-Z0-9_.-]+):[[:space:]]+([^[:space:]].*)$ ]]; then
                  candidate_name="''${match[2]}"
                  candidate_val="''${match[3]}"
                  if [[ "$candidate_name" != "http" && "$candidate_name" != "https" && "$candidate_name" != "ssh" && "$candidate_name" != "git" ]]; then
                    custom_name="$candidate_name"
                    repo="$candidate_val"
                  else
                    repo="$content"
                  fi
                elif [[ "$content" =~ ^-[[:space:]]+(.*)$ ]]; then
                  repo="''${match[1]}"
                else
                  repo="$content"
                fi

                repo="''${repo#\"}"
                repo="''${repo%\"}"
                repo="''${repo#'\''}"
                repo="''${repo%'\''}"
                repo="''${repo#"''${repo%%[![:space:]]*}"}"
                repo="''${repo%"''${repo##*[![:space:]]}"}"
                repo="''${repo%/}"

                if [[ "$repo" == *@* || "$repo" == http* || "$repo" == ssh://* || "$repo" == git://* || "$repo" == *.git ]]; then
                  repo_name="$custom_name"
                  if [[ -z "$repo_name" ]]; then
                    repo_name="''${repo##*/}"
                    repo_name="''${repo_name##*:}"
                    repo_name="''${repo_name%.git}"
                  fi
                  target="$HOME/$current_project/$repo_name"

                  if [[ ! -d "$target/.git" && ! -d "$target" ]]; then
                    echo "Cloning $repo -> $target"
                    ${pkgs.git}/bin/git clone "$repo" "$target" || true
                  fi
                fi
              fi
            done < "$projects_file"
          ' zsh "$PROJECTS_FILE"
        fi
      fi
    '';
  };
in
if args ? pkgs then
  module args
else
  module
