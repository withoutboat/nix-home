{ config, lib, options, ... }:

let
  rawSshSecrets = ../secrets/ssh.yml;
  hasSshSecrets = builtins.pathExists rawSshSecrets;
  isEncrypted = hasSshSecrets && (
    let content = builtins.readFile rawSshSecrets;
    in lib.hasInfix "sops:" content || lib.hasInfix "ENC[" content
  );
in
lib.mkMerge [
  {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          HostName = "github.com";
          IdentityFile = "~/.ssh/id_ed25519";
          IdentitiesOnly = true;
          IdentityAgent = "none";
        };
      };
    };
  }
  (lib.mkIf (isEncrypted && options ? sops) {
    sops.secrets."id_ed25519" = {
      sopsFile = rawSshSecrets;
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      mode = "0600";
    };
    sops.secrets."id_ed25519.pub" = {
      sopsFile = rawSshSecrets;
      path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      mode = "0644";
    };
  })
]
