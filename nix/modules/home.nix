{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    ffmpeg
    github-copilot-cli
    karabiner-elements
    signal-desktop
    slack
  ];
}
