{ pkgs, ... }:
let
  theme-set = pkgs.writeShellScriptBin "theme-set" (builtins.readFile ../scripts/theme-set);
  theme-toggle = pkgs.writeShellScriptBin "theme-toggle" (builtins.readFile ../scripts/theme-toggle);
in
{
  home.packages = [
    theme-set
    theme-toggle
  ];
}
