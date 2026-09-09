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

  outputs = { self, nix-hyprland, nix-ks3-infra, nix-neovim, sops-nix, ... }:
    let
      themes = pkgs: {
        default_dark = {
          name = "default_dark";
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
          image = pkgs.fetchurl {
            name = "catppuccin-mocha-waves.jpg";
            url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Dark%206016x6016.jpg";
            sha256 = "1a8e42ab67483980c79674e6b614990630ec4d176691e94e25ae5e6ff2c45d88";
          };
        };

        default_light = {
          name = "default_light";
          polarity = "light";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
          image = pkgs.fetchurl {
            name = "catppuccin-latte-waves.jpg";
            url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Light%206016x6016.jpg";
            sha256 = "6ab30f280e6c09a7e2df0df288c01b0f8a5ac1a70f3f65767a776963c9ced8ed";
          };
        };

        solarized_light = {
          name = "solarized_light";
          polarity = "light";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
          image = pkgs.fetchurl {
            name = "catppuccin-latte-waves.jpg";
            url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Light%206016x6016.jpg";
            sha256 = "6ab30f280e6c09a7e2df0df288c01b0f8a5ac1a70f3f65767a776963c9ced8ed";
          };
        };

        solarized_dark = {
          name = "solarized_dark";
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
          image = pkgs.fetchurl {
            name = "catppuccin-mocha-waves.jpg";
            url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Dark%206016x6016.jpg";
            sha256 = "1a8e42ab67483980c79674e6b614990630ec4d176691e94e25ae5e6ff2c45d88";
          };
        };

        tokyo_night_dark = {
          name = "tokyo_night_dark";
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
          image = pkgs.fetchurl {
            name = "catppuccin-mocha-waves.jpg";
            url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/waves/Waves%20Dark%206016x6016.jpg";
            sha256 = "1a8e42ab67483980c79674e6b614990630ec4d176691e94e25ae5e6ff2c45d88";
          };
        };
      };

      normalizeThemeName = name: {
        "solirized_light" = "solarized_light";
        "solorized_light" = "solarized_light";
        "solarized_light" = "solarized_light";
        "solorized_dark" = "solarized_dark";
        "solarized_dark" = "solarized_dark";
        "tokio_nigth_dark" = "tokyo_night_dark";
        "tokyo_night_dark" = "tokyo_night_dark";
        "tokyo_night" = "tokyo_night_dark";
        "default_dark" = "default_dark";
        "default_light" = "default_light";
      }.${name} or name;

      getUserConfig = username:
        let
          userConfigFile = ./configs + "/${username}.nix";
          rawConfig = if builtins.pathExists userConfigFile then
            import userConfigFile
          else
            {
              lightTheme = "default_light";
              darkTheme = "default_dark";
            };
        in
        {
          lightTheme = normalizeThemeName (rawConfig.lightTheme or "default_light");
          darkTheme = normalizeThemeName (rawConfig.darkTheme or "default_dark");
        };

      resolveTheme = pkgs: name:
        let
          normalized = normalizeThemeName name;
          all = themes pkgs;
        in
        all.${normalized} or all.default_dark;
    in
    {
      inherit themes getUserConfig resolveTheme normalizeThemeName;

      homeModules = {
        default = { pkgs, username, ... }: {
          imports = [
            sops-nix.homeManagerModules.sops
            nix-hyprland.homeManagerModules.default
            nix-ks3-infra.homeManagerModules.default
            nix-neovim.homeManagerModules.default
            ./modules/theme-config.nix
            ./modules/firefox.nix
            ./modules/ks3.nix
            ./modules/neovim.nix
            ./modules/projects.nix
            ./modules/scripts.nix
            ./modules/shell.nix
            ./modules/sops.nix
            ./modules/ssh.nix
            ./modules/zellij.nix
          ] ++ (
            let
              userConfigFile = ./configs + "/${username}.nix";
            in
            if builtins.pathExists userConfigFile then [ userConfigFile ] else [ ]
          );

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
