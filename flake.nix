{
  description = "Vladimir's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-hyprland.url = "github:withoutboat/nix-hyprland";
    nix-ks3-infra.url = "github:withoutboat/nix-ks3-infra";
    nix-ks3-infra.inputs.nixpkgs.follows = "nixpkgs";
    nix-neovim.url = "github:withoutboat/nix-neovim";
    nix-neovim.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nix-hyprland, nix-ks3-infra, nix-neovim, sops-nix, ... }:
    {
      homeModules = {
        default = { pkgs, username, ... }: {
          imports = [
            sops-nix.homeManagerModules.sops
            nix-hyprland.homeManagerModules.default
            nix-ks3-infra.homeManagerModules.default
            nix-neovim.homeManagerModules.default
            ./modules/firefox.nix
            ./modules/ks3.nix
            ./modules/neovim.nix
            ./modules/projects.nix
            ./modules/scripts.nix
            ./modules/shell.nix
            ./modules/sops.nix
            ./modules/ssh.nix
            ./modules/zellij.nix
          ];

          home.username = username;
          home.homeDirectory = "/home/${username}";
          home.stateVersion = "26.11";

          programs.home-manager.enable = true;
        };

        ks3 = {
          imports = [
            nix-ks3-infra.homeManagerModules.default
            ./modules/ks3.nix
          ];
        };

        neovim = {
          imports = [
            nix-neovim.homeManagerModules.default
            ./modules/neovim.nix
          ];
        };

        projects = {
          imports = [
            ./modules/projects.nix
          ];
        };

        scripts = {
          imports = [
            ./modules/scripts.nix
          ];
        };

        shell = {
          imports = [
            ./modules/shell.nix
          ];
        };

        sops = {
          imports = [
            sops-nix.homeManagerModules.sops
            ./modules/sops.nix
          ];
        };

        zellij = {
          imports = [
            ./modules/zellij.nix
          ];
        };
      };
    };
}
