{ lib, pkgs, ... }: {
  home.packages = with pkgs;
    [
      ffmpeg
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      karabiner-elements
    ];
}
