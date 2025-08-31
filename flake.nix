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
            nim nimlsp nimble
            nim_lk jq

            arduino-cli
          ];
          shellHook = ''
            nim_lk | jq --sort-keys > lock.json
            nimble install -d > /dev/null
            alias arduino-cli="arduino-cli --config-file ./arduino-cli.yaml"
            alias editor="lite-xl $PWD &"
            alias mk="make"
            alias nr="nix run"
          '';
        };
      };
      packages = {
        default = self'.packages.nimpad;
        nimpad = pkgs.callPackage ./default.nix { };
      };
    };
  };
}

