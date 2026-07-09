{
  description = "Vladimir's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: {
    # Этот модуль мы импортируем в nix-core
    homeModules.default = { config, pkgs, ... }: {
      imports = [
      ];

      home.username = config.home.username; 
      home.homeDirectory = "/home/${config.home.username}";
      home.stateVersion = "26.11";

      # Позволяет управлять Home Manager через NixOS
      programs.home-manager.enable = true;
    };
  };
}
