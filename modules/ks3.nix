{ pkgs, lib, ... }:

{
  # Minimal launch of rootless K3s user service
  services.k3s-infra = {
    enable = lib.mkDefault pkgs.stdenv.isLinux;
  };

  # Kubernetes client tooling (kubectl, helm, k9s, opentofu) and shell aliases
  programs.k3s-infra = {
    enable = lib.mkDefault true;
  };
}
