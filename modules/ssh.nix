{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        HostName = "github.com";
        IdentityFile = "~/.ssh/id_ed25519_sk";
        IdentitiesOnly = true;
        IdentityAgent = "none";
      };
    };
  };
}
