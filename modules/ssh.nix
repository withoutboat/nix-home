{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519_sk";
        identitiesOnly = true;
        identityAgent = "none";
      };
    };
  };
}
