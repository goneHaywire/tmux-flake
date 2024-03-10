{
  description = "My personal Tmux flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    flake-utils.url = "github:numtide/flake-utils";

    # TODO:
    # add personal nushell flake
    # add personal starship flake
    # add personal tmuxp flake
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        tmux-conf-file =
          pkgs.writeText "tmux.conf" (builtins.readFile ./tmux.conf);

        # TODO: alternative build method to keep manpage
        my-tmux = pkgs.writeShellApplication {
          name = "tmux";
          runtimeInputs = with pkgs; [tmux tmuxp nushell starship];
          text = "tmux -f ${tmux-conf-file}";
        };

      in {
        packages.default = my-tmux;
      });
}
