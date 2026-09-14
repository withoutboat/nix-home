{ pkgs, ... }:
let
  zellij-sessionizer = pkgs.writeShellScriptBin "zellij-sessionizer" ''
    export PATH="${pkgs.lib.makeBinPath [ pkgs.findutils pkgs.coreutils pkgs.gnugrep pkgs.fzf pkgs.zellij ]}:$PATH"
    exec ${pkgs.bash}/bin/bash ${../../scripts/zellij-sessionizer} "$@"
  '';
in
{
  home.packages = [
    zellij-sessionizer
    pkgs.fzf
  ];

  home.shellAliases = {
    zs = "zellij-sessionizer";
  };
}
