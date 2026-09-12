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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nix-hyprland, nix-ks3-infra, nix-neovim, sops-nix, stylix, ... }:
    {
      homeModules = {
        default = { pkgs, username, ... }: {
          imports = [
            sops-nix.homeManagerModules.sops
            nix-hyprland.homeManagerModules.default
            nix-ks3-infra.homeManagerModules.default
            nix-neovim.homeManagerModules.default
            ./modules/config.nix
            ./modules/theme.nix
            ./modules/firefox.nix
            ./modules/apps.nix
            ./modules/yubikey.nix
            ./modules/ks3.nix
            ./modules/neovim.nix
            ./modules/projects.nix
            ./modules/scripts.nix
            ./modules/shell.nix
            ./modules/sops.nix
            ./modules/ssh.nix
            ./modules/zellij.nix
            ./modules/ghostty.nix
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

        config = {
          imports = [
            ./modules/config.nix
          ];
        };

        sops = {
          imports = [
            sops-nix.homeManagerModules.sops
            ./modules/sops.nix
          ];
        };

        stylix = {
          imports = [
            stylix.homeModules.stylix
          ];
        };

        theme = {
          imports = [
            ./modules/config.nix
            ./modules/theme.nix
          ];
        };

        zellij = {
          imports = [
            ./modules/zellij.nix
          ];
        };

        apps = {
          imports = [
            ./modules/apps.nix
          ];
        };

        yubikey = {
          imports = [
            ./modules/yubikey.nix
          ];
        };

        ghostty = {
          imports = [
            ./modules/ghostty.nix
          ];
        };
      };
    };
}
