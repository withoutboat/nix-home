{
  home =
    { config, lib, ... }:
    let
      cfg = config.services.amneziawg;
    in
    {
      options.services.amneziawg = {
        enable = lib.mkEnableOption "AmneziaWG integration hint for NixOS";

        configFile = lib.mkOption {
          type = with lib.types; nullOr str;
          default = null;
          example = "/run/secrets/amnezia/amnezia.conf";
          description = ''
            Path to an AmneziaWG 2.0 `amnezia.conf` file. Home Manager does not
            activate system VPN networking; this option is only a declarative place
            to keep the value and documentation next to your home configuration.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        warnings = [
          "services.amneziawg.* in nix-home (Home Manager) does not enable a system-wide VPN. Import inputs.nix-home.nixosModules.amnezia in nix-core/NixOS and configure the same configFile there."
        ];
      };
    };

  nixos =
    { config, lib, ... }:
    let
      cfg = config.services.amneziawg;
      ifName = cfg.interfaceName;
    in
    {
      options.services.amneziawg = {
        enable = lib.mkEnableOption "AmneziaWG 2.0 through networking.wg-quick";

        interfaceName = lib.mkOption {
          type = lib.types.str;
          default = "awg0";
          example = "amnezia0";
          description = "Name of the AmneziaWG network interface.";
        };

        configFile = lib.mkOption {
          type = with lib.types; nullOr str;
          default = builtins.toString ./amnezia_for_awg.conf;
          example = "/run/secrets/amnezia/amnezia.conf";
          description = ''
            Path to an AmneziaWG 2.0 config in awg-quick format.

            The file is consumed at service start (not at Nix evaluation time), so
            secrets are not read with builtins.readFile and are not copied into the
            Nix store by this module. By default, this points to the repository test
            config `amnezia_for_awg.conf`.
          '';
        };

        autoStart = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Start the tunnel automatically during boot.";
        };

        killSwitch.enable = lib.mkEnableOption "kill-switch for AmneziaWG";
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = cfg.configFile != null;
            message = "services.amneziawg.configFile must be set when services.amneziawg.enable = true.";
          }
          {
            assertion = !cfg.killSwitch.enable;
            message = ''
              services.amneziawg.killSwitch.enable is intentionally not implemented yet,
              because a safe default kill-switch is deployment-specific and can block
              SSH/LAN access. Keep it disabled or add explicit firewall policy in nix-core.
            '';
          }
        ];

        networking.wg-quick.interfaces.${ifName} = {
          type = "amneziawg";
          configFile = cfg.configFile;
          autostart = cfg.autoStart;
        };

        systemd.services = lib.mkIf config.networking.networkmanager.enable {
          "wg-quick-${ifName}" = {
            wants = [ "NetworkManager-wait-online.service" ];
            after = [ "NetworkManager-wait-online.service" ];
          };
        };
      };
    };
}
