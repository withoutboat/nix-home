{ pkgs }:

let
  releaseBase = "https://github.com/withoutboat/nix-home/releases/download/wallpapers-v1";
in
{
  autumn = pkgs.fetchurl {
    name = "autumn-river-mountain-moewalls-com.mp4";
    url = "${releaseBase}/autumn-river-mountain-moewalls-com.mp4";
    sha256 = "be8d5ae330c6143b6e6c698a74413f71c745439ca810678d8c9bd0ddb4471461";
  };

  camp = pkgs.fetchurl {
    name = "camp-fire-dead-by-daylight-moewalls-com.mp4";
    url = "${releaseBase}/camp-fire-dead-by-daylight-moewalls-com.mp4";
    sha256 = "f4129b8fb4f43d5b91dc6cdef7d31b26e6b05c67b1541972c609c86162627ec4";
  };

  barrel = pkgs.fetchurl {
    name = "barrel-fire-pixel-moewalls-com.mp4";
    url = "${releaseBase}/barrel-fire-pixel-moewalls-com.mp4";
    sha256 = "b0f4863f708986f6feea70d050505305e093ff67cae1ca6a39ce737f028adf77";
  };

  black_cat = pkgs.fetchurl {
    name = "black-cat-blue-sky-moewalls-com.mp4";
    url = "${releaseBase}/black-cat-blue-sky-moewalls-com.mp4";
    sha256 = "da914017f9a0cefcc34654e75724ca95f1b990ed1be4e214d6f1ed74e0167545";
  };

  lofi_girl = pkgs.fetchurl {
    name = "lofi-girl-and-cat-watching-fireworks-moewalls-com.mp4";
    url = "${releaseBase}/lofi-girl-and-cat-watching-fireworks-moewalls-com.mp4";
    sha256 = "6973a1b0d66b9f2d944ac106987e61cf0ab4bd9bb286b8cc3104a0ef0876a717";
  };

  posters = {
    autumn = pkgs.fetchurl {
      name = "autumn.jpg";
      url = "${releaseBase}/autumn.jpg";
      sha256 = "dd80ea81c667312600248bbf1af4edfddfa5f3852af9801a705fd22c911970b9";
    };

    camp = pkgs.fetchurl {
      name = "camp.jpg";
      url = "${releaseBase}/camp.jpg";
      sha256 = "d2a4b97b842e92dc7e67e20786b192d8c28956267449a102d766e0dad7945efd";
    };
  };
}
