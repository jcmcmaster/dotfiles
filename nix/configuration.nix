{ username, ... }: {
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.primaryUser = username;

  # Necessary for Determinate Nix to work correctly with nix-darwin
  nix.enable = false;

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  programs.fish.enable = true;

  system.stateVersion = 4;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    casks = [
      "copilot-cli"
      "docker-desktop"
      "spotify"
    ];
  };
}
