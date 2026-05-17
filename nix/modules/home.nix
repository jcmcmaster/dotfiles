{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    ffmpeg
    karabiner-elements
    signal-desktop
    slack
  ];
}
