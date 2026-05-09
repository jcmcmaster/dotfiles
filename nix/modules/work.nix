{ pkgs, ... }: {
  home.packages = with pkgs; [
    azure-cli
    docker
    jetbrains.rider
    postman
    terraform
  ];
}
