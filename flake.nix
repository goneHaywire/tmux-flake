{
  description = "My personal Tmux flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = with pkgs; [ tmux tmuxp nushell];

        tmux-conf-file = pkgs.writeText "tmux.conf" (builtins.readFile ./tmux.conf);

        tmux-wrapper = pkgs.writeShellApplication {
          name = "tmux-wrapper";
          runtimeInputs = packages ++ [tmux-conf-file];
          text = "${pkgs.tmux} -f ${tmux-conf-file}";
        };

      in {
        devShells.default = pkgs.mkShell {
          # packages = [ tmux-wrapper pkgs.tmuxp ];

          shellhook = "${tmux-wrapper}/bin/tmux-wrapper";
        };

        packages.default = tmux-wrapper;

        apps.default = {
          type = "app";
          program = "${tmux-wrapper}/bin/tmux-wrapper";
        };

        # formatter.${system} = pkgs.nixfmt;
      });
}
