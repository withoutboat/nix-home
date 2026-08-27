{
  description = "Vladimir's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-hyprland.url = "github:withoutboat/nix-hyprland";
  };

  outputs = { nix-hyprland, ... }:
    let
      networkModules = import ./network.nix;
    in
    {
      homeModules.default = { pkgs, username, ... }: {
        imports = [
          nix-hyprland.homeManagerModules.default
          networkModules.home
        ];

        home.username = username;
        home.homeDirectory = "/home/${username}";
        home.stateVersion = "26.11";

        programs.home-manager.enable = true;
      };

      nixosModules.amnezia = networkModules.nixos;
    };
}
