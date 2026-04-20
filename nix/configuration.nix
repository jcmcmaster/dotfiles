{ pkgs, config, username, ... }: {
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.primaryUser = username;

  # Necessary for Determinate Nix to work correctly with nix-darwin
  nix.enable = false;

  programs.fish.enable = true;

  system.stateVersion = 4;

  nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;
  nixpkgs.config.allowUnfree = true;

  homebrew = {
    enable = true;
    casks = [
      "keeper-password-manager"
    ];
  };
}

