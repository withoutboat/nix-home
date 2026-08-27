# nix-home

`nix-home` exports:

- `homeModules.default` — Home Manager module (includes `nix-hyprland` and lightweight AmneziaWG options)
- `nixosModules.amnezia` — **system-level** AmneziaWG 2.0 module for NixOS

## Important architecture note

VPN setup (kernel module, routes, DNS, full-tunnel, service ordering, firewall policy) is a **NixOS/system** responsibility.
Home Manager cannot safely enforce system-wide full-tunnel behavior by itself.

Because of that, `services.amneziawg.*` inside `homeModules.default` is informational only and shows a warning when enabled.
Use `inputs.nix-home.nixosModules.amnezia` in your `nix-core` (or any NixOS config) to actually enable the tunnel.

## NixOS integration (in nix-core)

In your NixOS flake/module set:

```nix
{
  imports = [
    inputs.nix-home.nixosModules.amnezia
  ];

  services.amneziawg = {
    enable = true;
    interfaceName = "awg0";
    configFile = "/run/secrets/amnezia/amnezia.conf";
    autoStart = true;

    # intentionally opt-in and currently not implemented by this module
    killSwitch.enable = false;
  };
}
```

## About `amnezia.conf` and secrets

- Do **not** commit a real `amnezia.conf` with private keys.
- Keep it outside Git (`/run/secrets/...`, `/etc/secrets/...`, sops/agenix, etc.).
- This module does not use `builtins.readFile` for the config, so secret content is not read at evaluation time.
- The module does not auto-load `./amnezia_for_awg.conf` (or any other repo-local fallback); set `services.amneziawg.configFile` explicitly in your NixOS config.

## Full-tunnel notes

This module relies on upstream `networking.wg-quick.interfaces.<name>.type = "amneziawg"`.
For full tunnel, your `amnezia.conf` should contain the expected peer routes such as `AllowedIPs = 0.0.0.0/0` and (if needed) `::/0`.
Route-loop avoidance for endpoint reachability is delegated to upstream `awg-quick` behavior.

If you customize `Table`/policy-routing manually in `amnezia.conf`, verify your routing design explicitly.

## Compatibility

This implementation depends on nixpkgs support for:

- `networking.wg-quick.interfaces.<name>.type = "amneziawg"`
- `pkgs.amneziawg-tools` / kernel support wired by NixOS module

If your pinned nixpkgs revision lacks these, update nixpkgs to a revision that contains AmneziaWG support.
