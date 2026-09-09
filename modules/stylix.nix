{ config, lib, options, pkgs, ... }:

let
  # Catppuccin Mocha (dark theme) base16 palette
  catppuccinMocha = {
    base00 = "1e1e2e"; # Base background
    base01 = "181825"; # Mantle / darker background
    base02 = "313244"; # Surface 0 / selection background
    base03 = "45475a"; # Surface 1 / comments
    base04 = "585b70"; # Surface 2 / dark foreground
    base05 = "cdd6f4"; # Text / default foreground
    base06 = "f5e0dc"; # Rosewater / light foreground
    base07 = "b4befe"; # Lavender / light background
    base08 = "f38ba8"; # Red
    base09 = "fab387"; # Peach / orange
    base0A = "f9e2af"; # Yellow
    base0B = "a6e3a1"; # Green
    base0C = "94e2d5"; # Teal / cyan
    base0D = "89b4fa"; # Blue
    base0E = "cba6f7"; # Mauve / magenta
    base0F = "f2cdcd"; # Flamingo / maroon
  };

  # Catppuccin Latte (light theme) base16 palette
  catppuccinLatte = {
    base00 = "eff1f5"; # Base background
    base01 = "e6e9ef"; # Mantle / darker background
    base02 = "ccd0da"; # Surface 0 / selection background
    base03 = "bcc0cc"; # Surface 1 / comments
    base04 = "acb0be"; # Surface 2 / dark foreground
    base05 = "4c4f69"; # Text / default foreground
    base06 = "dc8a78"; # Rosewater / light foreground
    base07 = "7287fd"; # Lavender / light background
    base08 = "d20f39"; # Red
    base09 = "fe640b"; # Peach / orange
    base0A = "df8e1d"; # Yellow
    base0B = "40a02b"; # Green
    base0C = "179299"; # Teal / cyan
    base0D = "1e66f5"; # Blue
    base0E = "8839ef"; # Mauve / magenta
    base0F = "dd7878"; # Flamingo / maroon
  };

  # Format palette attributes to include withHashtag helper matching Stylix lib API
  mkColors = palette: palette // {
    withHashtag = lib.mapAttrs (_: hex: "#${hex}") palette;
  };

  hasStylix = options ? stylix && config ? stylix && config.stylix.enable;
in
{
  config = lib.mkMerge [
    {
      # Export base16 palettes for direct reference
      lib.stylix.palettes = {
        mocha = mkColors catppuccinMocha;
        latte = mkColors catppuccinLatte;
      };
    }

    # When Stylix is not loaded or not enabled, export default colors under config.lib.stylix.colors
    # so all dependent modules (Zellij, Shell, Starship) have a guaranteed single source of truth.
    (lib.mkIf (!hasStylix) {
      lib.stylix.colors = mkColors catppuccinMocha;
    })

    # When Stylix is available, configure it declaratively
    (lib.optionalAttrs (options ? stylix) {
      stylix = {
        enable = lib.mkDefault true;
        polarity = lib.mkDefault "dark";
        base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

        targets = {
          zellij.enable = lib.mkDefault true;
          nushell.enable = lib.mkDefault true;
          starship.enable = lib.mkDefault true;
        };
      };

      # Specialisation for light theme (Catppuccin Latte)
      specialisation.light.configuration = lib.mkIf (options ? specialisation) {
        stylix = {
          polarity = lib.mkForce "light";
          base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
        };
      };
    })
  ];
}
