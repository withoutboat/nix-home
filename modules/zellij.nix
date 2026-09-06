{ pkgs, lib, options, ... }:

let
  zellij-sessionizer = pkgs.writeShellScriptBin "zellij-sessionizer" (builtins.readFile ../scripts/zellij-sessionizer);
in
lib.mkMerge [
  {
    programs.zellij = {
      enable = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      settings = {
        default_shell = "nu";
      };
      extraConfig = ''
        keybinds {
            shared_except "locked" {
                bind "Alt s" {
                    LaunchOrFocusPlugin "session-manager" {
                        floating true
                        move_to_focused_tab true
                    }
                }
            }
        }
      '';
    };

    home.packages = [
      zellij-sessionizer
      pkgs.fzf
    ];

    home.shellAliases = {
      zj = "zellij";
      zs = "zellij-sessionizer";
    };
  }
  (lib.optionalAttrs (options ? stylix) {
    stylix.targets.zellij.enable = lib.mkDefault true;
    programs.zellij.settings.theme = lib.mkDefault "stylix";
  })
]
