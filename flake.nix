{
  description = "Vladimir's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-hyprland.url = "github:withoutboat/nix-hyprland";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nix-hyprland, nur, ... }:
    {
      homeModules.default = { pkgs, username, ... }: {
        nixpkgs.overlays = [
          nur.overlays.default
        ];

        imports = [
          nix-hyprland.homeManagerModules.default
          ./modules/firefox.nix
        ];

        home.username = username;
        home.homeDirectory = "/home/${username}";
        home.stateVersion = "26.11";

        programs.home-manager.enable = true;
      };
    };
}
