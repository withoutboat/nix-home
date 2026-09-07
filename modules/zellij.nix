{ lib, options, ... }:

lib.mkMerge [
  {
    imports = [
      ./scripts.nix
    ];

    programs.zellij = {
      enable = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      settings = {
        default_shell = "nu";
      };
      extraConfig = ''
        keybinds {
            normal {
                bind "Ctrl f" {
                    Run "zellij-sessionizer" {
                        floating true
                        close_on_exit true
                        x "20%"
                        y "20%"
                        width "60%"
                        height "60%"
                    }
                }
            }
            session {
                bind "f" "s" "Ctrl f" {
                    Run "zellij-sessionizer" {
                        floating true
                        close_on_exit true
                        x "20%"
                        y "20%"
                        width "60%"
                        height "60%"
                    }
                    SwitchToMode "Normal"
                }
            }
            tmux {
                bind "f" {
                    Run "zellij-sessionizer" {
                        floating true
                        close_on_exit true
                        x "20%"
                        y "20%"
                        width "60%"
                        height "60%"
                    }
                    SwitchToMode "Normal"
                }
            }
            shared_except "locked" {
                bind "Alt s" {
                    LaunchOrFocusPlugin "session-manager" {
                        floating true
                        move_to_focused_tab true
                    }
                }
                bind "Alt f" {
                    Run "zellij-sessionizer" {
                        floating true
                        close_on_exit true
                        x "20%"
                        y "20%"
                        width "60%"
                        height "60%"
                    }
                }
            }
        }
      '';
    };

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
