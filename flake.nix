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

        tmux-conf = pkgs.tmux.overrideAttrs (oldAttrs: {
          buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          postInstall = (oldAttrs.postInstall or "") + ''
            mkdir $out/libexec

            mv $out/bin/tmux $out/libexec/tmux-unwrapped

            makeWrapper $out/libexec/tmux-unwrapped $out/bin/tmux \
              --add-flags "-f ${
                pkgs.writeText "tmux.conf" (builtins.readFile ./tmux.conf)
              }"
          '';
        });

      in {
        devShells.default = pkgs.mkShell { packages = [tmux-conf pkgs.tmuxp]; };

        packages.default = tmux-conf;

        # formatter.${system} = pkgs.nixfmt;
      });
}
