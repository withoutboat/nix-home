{ lib, options, ... }:

lib.mkMerge [
  {
    programs.ghostty = {
      enable = lib.mkDefault true;
      settings = {
        background-opacity = lib.mkDefault 0.8;
      };
    };
  }
  (lib.optionalAttrs (options ? stylix) {
    stylix.targets.ghostty.enable = lib.mkDefault true;
  })
]
