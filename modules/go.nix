{ config, lib, pkgs, ... }:

let
  goCacheDir = "${config.xdg.cacheHome}/go";
  goBinDir = "${goCacheDir}/bin";
in
{
  programs.go = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.go;
    env = {
      GOPATH = goCacheDir;
      GOBIN = goBinDir;
    };
  };

  home.sessionVariables = {
    GOPATH = goCacheDir;
    GOBIN = goBinDir;
  };

  home.sessionPath = [
    goBinDir
  ];

  home.packages = with pkgs; [
    gopls
    golangci-lint
    delve
    gotools
  ];
}
