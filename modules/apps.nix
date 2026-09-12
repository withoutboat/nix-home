{ lib, pkgs, ... }:

let
  github-copilot-desktop = pkgs.appimageTools.wrapType2 rec {
    pname = "github-copilot";
    version = "1.1.19";

    src = pkgs.fetchurl {
      url = "https://github.com/github/app/releases/download/v${version}/GitHub-Copilot-linux-x64.AppImage";
      hash = "sha256-aPbjY2ufweNG7VK04pXfq+Jod+VTWhtynwU6UYqNDmI=";
    };

    extraPkgs = pkgs: with pkgs; [
      webkitgtk_4_1
      glib-networking
      openssl
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
in
{
  home.packages = with pkgs; [
    telegram-desktop
    zoom-us
    slack
    github-copilot-desktop
  ];
}
