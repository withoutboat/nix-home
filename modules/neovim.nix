{ config, lib, options, ... }:

let
  hasSops = options ? sops;
in
{
  programs.nixvim = {
    enable = lib.mkDefault true;
    defaultEditor = lib.mkDefault true;
    viAlias = lib.mkDefault true;
    vimAlias = lib.mkDefault true;
  };

  home.sessionVariables = {
    EDITOR = lib.mkDefault "nvim";
    VISUAL = lib.mkDefault "nvim";
  };

  home.shellAliases = {
    v = "nvim";
    vim = "nvim";
  };

  # GitHub Copilot declarative authentication
  # Copilot reads authentication credentials from ~/.config/github-copilot/hosts.json
  sops = lib.mkIf hasSops {
    secrets."copilot/hosts.json" = lib.mkDefault {
      path = "${config.xdg.configHome}/github-copilot/hosts.json";
    };
  };
}
