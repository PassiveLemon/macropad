{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = { ... } @ inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" ];

    perSystem = { self', system, ... }:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    {
      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            arduino-cli
          ];
          shellHook = ''
            alias arduino-cli="arduino-cli --config-file ./arduino-cli.yaml"
            alias editor="lite-xl $PWD &"
          '';
        };
      };
      packages = {
        default = self'.packages.shell;
        shell = pkgs.writeShellApplication {
          name = "shell";
          text = ''
            nix develop
          '';
        };
      };
    };
  };
}

