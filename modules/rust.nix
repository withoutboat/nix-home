{ config, lib, pkgs, ... }:

let
  cargoHome = "${config.xdg.dataHome}/cargo";
  cargoBin = "${cargoHome}/bin";
in
{
  home.sessionVariables = {
    CARGO_HOME = cargoHome;
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
  };

  home.sessionPath = [
    cargoBin
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.packages = with pkgs; [
    rustc
    cargo
    clippy
    rustfmt
    rust-analyzer
  ];
}
