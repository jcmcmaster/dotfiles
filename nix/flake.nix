{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nix-darwin, nixpkgs, home-manager, ... }:
  let
    system = "aarch64-darwin";
    profiles = [ "home" "work" ];
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
      overlays = [
        (_: previous: {
          bicep-lsp =
            let
              bundle = previous.fetchzip {
                url = "https://github.com/Azure/bicep/releases/download/v0.34.44/bicep-langserver.zip";
                hash = "sha256-BzApHse1rQoq//nASULKayFG0C2gaU+CrX9vOCncIb8=";
                stripRoot = false;
              };
            in
            previous.writeShellScriptBin "Bicep.LangServer" ''
              exec ${previous.dotnetCorePackages.runtime_8_0}/bin/dotnet \
                ${bundle}/Bicep.LangServer.dll "$@"
            '';
        })
      ] ++ nixpkgs.lib.optionals (builtins.pathExists /etc/nix/macos-keychain.crt) [
        (_: previous: {
          terraform = previous.terraform.override {
            buildGo127Module = previous.buildGo127Module.override {
              cacert = previous.cacert.override {
                extraCertificateFiles = [ /etc/nix/macos-keychain.crt ];
              };
            };
          };
        })
      ];
    };
    mkHome = profile: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit name email username; };
      modules = [
        ./home-manager/common.nix
        ./home-manager/${profile}.nix
      ];
    };
    mkDarwin = profile: nix-darwin.lib.darwinSystem {
      inherit system pkgs;
      specialArgs = { inherit username; };
      modules = [
        ./nix-darwin/common.nix
        ./nix-darwin/${profile}.nix
      ];
    };
  in {
    homeConfigurations = nixpkgs.lib.genAttrs profiles mkHome;
    darwinConfigurations = nixpkgs.lib.genAttrs profiles mkDarwin;
  };
}
