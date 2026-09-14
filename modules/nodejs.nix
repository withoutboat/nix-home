{ config, lib, pkgs, ... }:

let
  npmGlobal = "${config.xdg.dataHome}/npm";
  npmBin = "${npmGlobal}/bin";
  pnpmHome = "${config.xdg.dataHome}/pnpm";
in
{
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = npmGlobal;
    PNPM_HOME = pnpmHome;
  };

  home.sessionPath = [
    npmBin
    pnpmHome
  ];

  home.packages = with pkgs; [
    nodejs
    pnpm
    yarn
  ];
}
