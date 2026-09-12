{ lib, pkgs, ... }:

let
  version = "1.1.19";

  github-copilot-desktop-unwrapped = pkgs.appimageTools.wrapType2 {
    pname = "github-copilot-unwrapped";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-x64.AppImage";
      hash = "sha256-aPbjY2ufweNG7VK04pXfq+Jod+VTWhtynwU6UYqNDmI=";
    };

    extraPkgs = pkgs: with pkgs; [
      webkitgtk_4_1
      glib-networking
      openssl
      curl
      git
    ];

    extraInstallCommands = ''
      install -m 444 -D ${desktopItem}/share/applications/github-copilot.desktop $out/share/applications/github-copilot.desktop
    '';
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "github-copilot";
    desktopName = "GitHub Copilot";
    comment = "Tauri Copilot Application";
    exec = "github-copilot %u";
    icon = "github-copilot";
    terminal = false;
    startupWMClass = "github";
    categories = [ "Development" ];
    mimeTypes = [
      "x-scheme-handler/github-app"
      "x-scheme-handler/ghapp"
      "x-scheme-handler/gh"
    ];
  };

  github-copilot-desktop = pkgs.symlinkJoin {
    name = "github-copilot-${version}";
    paths = [
      (pkgs.writeShellScriptBin "github-copilot" ''
        fix_copilot_git() {
          local dir="$1"
          mkdir -p "$dir"
          if [ ! -L "$dir/bin" ] || [ "$(readlink "$dir/bin")" != "${pkgs.git}/bin" ]; then
            rm -rf "$dir/bin" "$dir/libexec"
            ln -sfn "${pkgs.git}/bin" "$dir/bin"
            ln -sfn "${pkgs.git}/libexec" "$dir/libexec"
          fi
        }

        for dir in "$HOME/.cache"/github-copilot-git-*; do
          if [ -d "$dir" ]; then
            fix_copilot_git "$dir"
          fi
        done
        fix_copilot_git "$HOME/.cache/github-copilot-git-2.53.0-4"

        exec "${github-copilot-desktop-unwrapped}/bin/github-copilot-unwrapped" "$@"
      '')
      github-copilot-desktop-unwrapped
    ];
  };
in
{
  home.packages = with pkgs; [
    telegram-desktop
    zoom-us
    slack
    github-copilot-desktop
  ];

  home.activation.copilotGitFix = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    fix_copilot_git() {
      local dir="$1"
      mkdir -p "$dir"
      if [ ! -L "$dir/bin" ] || [ "$(readlink "$dir/bin")" != "${pkgs.git}/bin" ]; then
        rm -rf "$dir/bin" "$dir/libexec"
        ln -sfn "${pkgs.git}/bin" "$dir/bin"
        ln -sfn "${pkgs.git}/libexec" "$dir/libexec"
      fi
    }

    for dir in "$HOME/.cache"/github-copilot-git-*; do
      if [ -d "$dir" ]; then
        fix_copilot_git "$dir"
      fi
    done
    fix_copilot_git "$HOME/.cache/github-copilot-git-2.53.0-4"
  '';
}
