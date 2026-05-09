{ pkgs, ... }: {
  home.packages = with pkgs; [
    ffmpeg
    google-chrome
    obsidian
    raycast
    rectangle
    spotify
  ];
}
