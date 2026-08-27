# nix-home

`nix-home` exports:

- `homeModules.default` — Home Manager module with shared user configuration and `nix-hyprland`

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
