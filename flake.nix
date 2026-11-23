{
  description = "Developement Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    utils.url = "github:numtide/flake-utils";

    # customSurferFlake.url = "git+https://cmcgann.com/githttp/surfer.git?rev=a2815e1ac142aaf43de6b500de6282bf60aca100&shallow=1";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            rocmSupport = true;
          };
        };

        # customSurfer = customSurferFlake.packages.${system}.default;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            (pkgs.python3.withPackages (ps: with ps; [
              jupyter
              notebook
              numpy
              pandas
              matplotlib
              torch
              torchvision
              tensorboard
              tensorboardx
            ]))

            pkgs.verilator
            pkgs.gtkwave
            pkgs.surfer
            pkgs.zlib
            pkgs.graphviz
            pkgs.pandoc
            pkgs.iverilog
          ];
        };
      });
}

