{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
  let
    system = "aarch64-darwin";
    username = builtins.getEnv "SUDO_USER";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    user = builtins.getEnv "USER";
    mkHome = extraModules: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./modules/common.nix
        {
          home.username = user;
          home.homeDirectory = "/Users/${user}";
        }
      ] ++ extraModules;
    };
  in {
    homeConfigurations = {
      "work" = mkHome [ ./modules/work.nix ];
      "home" = mkHome [ ./modules/home.nix ];
      "default" = mkHome [ ./modules/home.nix ]; # backward compat
    };

    darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      specialArgs = { inherit username; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}

