{ pkgs, lib, ... }:

{
  # Minimal launch of rootless K3s user service
  services.k3s-infra = {
    enable = lib.mkDefault pkgs.stdenv.hostPlatform.isLinux;
  };

  # Kubernetes client tooling (kubectl, helm, k9s, opentofu) and shell aliases
  # Disable standalone kubectl since k3s already provides /bin/kubectl
  programs.k3s-infra = {
    enable = lib.mkDefault true;
    tools.kubectl.enable = false;
  };
}
