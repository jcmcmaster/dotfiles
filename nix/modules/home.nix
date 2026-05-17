{ pkgs, ... }: {
  home.packages = with pkgs; [
    ffmpeg
    karabiner-elements
  ];
}
