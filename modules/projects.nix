args@{ ... }:

let
  module = { config, lib, pkgs, inputs ? {}, ... }@moduleArgs:
  let
    inputs' = moduleArgs.inputs or {};
    nix-bin' = args.nix-bin or moduleArgs.nix-bin or inputs'.nix-bin or null;
    system = pkgs.stdenv.hostPlatform.system;
    projector =
      if nix-bin' != null
      then (nix-bin'.packages.${system}.projector or null)
      else pkgs.projector or null;

    projectorDir = "${config.xdg.configHome}/projector";
    projectsFile = "${projectorDir}/projects.yml";
    rootsFile = "${projectorDir}/roots";
  in
  {
    home.packages = lib.optional (projector != null) projector;

    sops.secrets."projects.yml" = {
      sopsFile = ../secrets/projects.yml;
      format = "yaml";
      key = "";
      path = projectsFile;
    };

    home.activation.projector = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -f "${projectsFile}" ]; then
        mkdir -p "${projectorDir}"
        if [ -n "${if projector != null then "${projector}/bin/projector" else ""}" ]; then
          export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"
          echo "==> Synchronizing projects with projector..."
          ${projector}/bin/projector "${projectsFile}" || true
        else
          grep -E '^[a-zA-Z0-9_.-]+:' "${projectsFile}" | grep -v '^sops:' | sed "s|^|$HOME/|; s|:.*||" > "${rootsFile}" || true
        fi
      fi
    '';
  };
in
if args ? pkgs then
  module args
else
  module

