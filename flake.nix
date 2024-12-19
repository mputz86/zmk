{
  description = "Project Name";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    nixpkgsFor = system: import nixpkgs {inherit system;};
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgsFor system;
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          podman
          # gnumake
          # cmake
        ];
      };
    });
}
