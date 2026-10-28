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
    username =
      let
        sudoUser = builtins.getEnv "SUDO_USER";
        user = builtins.getEnv "USER";
      in
        if sudoUser != "" then sudoUser else user;
    name = "Jim McMaster";
    email =
      let
        value = builtins.getEnv "EMAIL";
      in
        if value != "" then value else "jmcmaster008@gmail.com";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    workPkgs = pkgs.extend (_: previous: {
      cacert = previous.cacert.override {
        extraCertificateFiles = [ /etc/nix/macos-keychain.crt ];
      };
    });
    mkHome = pkgs: extraModules: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit name email; };
      modules = [
        ./modules/common.nix
        {
          home.username = username;
          home.homeDirectory = "/Users/${username}";
        }
      ] ++ extraModules;
    };
    mkDarwin = pkgs: extraModules: nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      specialArgs = { inherit username; };
      modules = [
        ./configuration.nix
      ] ++ extraModules;
    };
  in {
    homeConfigurations = {
      "work" = mkHome workPkgs [ ./modules/work.nix ];
      "home" = mkHome pkgs [ ./modules/home.nix ];
    };

    darwinConfigurations = {
      "work" = mkDarwin workPkgs [ ./modules/darwin-work.nix ];
      "home" = mkDarwin pkgs [ ./modules/darwin-home.nix ];
    };
  };
}
