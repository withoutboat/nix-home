{
  description = "Vladimir's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-hyprland.url = "github:withoutboat/nix-hyprland";
    nix-ks3-infra.url = "github:withoutboat/nix-ks3-infra";
    nix-ks3-infra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nix-hyprland, nix-ks3-infra, ... }:
    {
      homeModules = {
        default = { pkgs, username, ... }: {
          imports = [
            nix-hyprland.homeManagerModules.default
            nix-ks3-infra.homeManagerModules.default
            ./modules/firefox.nix
            ./modules/ks3.nix
            ./modules/scripts.nix
            ./modules/sops.nix
            ./modules/ssh.nix
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
      };
    };
}
