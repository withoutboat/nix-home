{ config, lib, pkgs, ... }:

let
  projectsFile =
    if config ? sops && config.sops.secrets ? "projects.yml"
    then config.sops.secrets."projects.yml".path
    else ../secrets/projects.yml;
in
{
  imports = [
    ./scripts.nix
  ];

  sops.secrets."projects.yml" = {
    sopsFile = ../secrets/projects.yml;
  };

  home.activation.cloneProjects = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PROJECTS_FILE="${projectsFile}"
    if [ ! -f "$PROJECTS_FILE" ] && [ -f "${../secrets/projects.yml}" ]; then
      PROJECTS_FILE="${../secrets/projects.yml}"
    fi

    if [ -f "$PROJECTS_FILE" ]; then
      ${pkgs.zsh}/bin/zsh ${../scripts/projects-clone} "$PROJECTS_FILE"
    fi
  '';
}
