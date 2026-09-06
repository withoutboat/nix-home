# nix-home

`nix-home` exports:

- `homeModules.default` — Home Manager module with shared user configuration, `nix-hyprland`, and `nix-ks3-infra`
- `homeModules.ks3` — standalone minimal K3s rootless service and Kubernetes tooling module (`programs.k3s-infra` / `services.k3s-infra`)

This repository is intended for reusable Home Manager configuration only.
Machine-specific system networking and VPN setup should live in `withoutboat/nix-core`.

## Usage

```nix
{
  imports = [
    inputs.nix-home.homeModules.default
  ];
}
```
