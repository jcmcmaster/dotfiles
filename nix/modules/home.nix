{ lib, pkgs, ... }: {
  home.packages = with pkgs;
    [
      ffmpeg
      utm
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      karabiner-elements
    ];
}
