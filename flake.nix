{
  description = "My personal Tmux flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    flake-utils.url = "github:numtide/flake-utils";

    # add personal nushell flake
    # add personal tmuxp flake
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        tmux-conf-file =
          pkgs.writeText "tmux.conf" (builtins.readFile ./tmux.conf);

        my-tmux = pkgs.writeShellApplication {
          name = "tmux";
          runtimeInputs = with pkgs; [tmux tmuxp nushell starship];
          text = "tmux -f ${tmux-conf-file}";
        };

      in {
        devShells.default = pkgs.mkShell {
          packages = [my-tmux] ++ (with pkgs; [tmuxp nushell starship]);

          # shellhook = "${my-tmux}/bin/tmux";
        };

        packages.tmux = my-tmux;
        packages.old-tmux = pkgs.tmux;
        packages.default = self.packages.${system}.tmux;
      });
}
