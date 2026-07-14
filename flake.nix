{
  description = "Vladimir's Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, hyprland } @ inputs: {
    homeModules.default = { pkgs, username, ... }: {
      extraSpecialArgs = { inherit inputs; };

      imports = [
        ./modules/wyland.nix
      ];

      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "26.11";

      programs.home-manager.enable = true;
    };
  };
}
