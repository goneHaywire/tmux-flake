{
  description = "My personal Tmux flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = with pkgs; [ tmux tmuxp ];
      in {
        devShells.default = pkgs.mkShell { inherit packages; };

        packages.default = pkgs.tmuxp;

        # apps.${system}.default = {
        #   type = "app";
        #   program = pkgs.tmux;
        # };

        # formatter.${system} = pkgs.nixfmt;
      });
}
