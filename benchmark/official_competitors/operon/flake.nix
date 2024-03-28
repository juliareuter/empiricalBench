{
  description = "jupyter";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    pypi-deps-db.url = "github:DavHau/pypi-deps-db";
    pyoperon.url = "github:heal-research/pyoperon/cpp20";

    mach-nix = {
      url = "github:DavHau/mach-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        pypi-deps-db.follows = "pypi-deps-db";
      };
    };
  };

  outputs = { self, flake-utils, mach-nix, nixpkgs, pypi-deps-db, pyoperon }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        python = "python39";
        pkgs = import nixpkgs { inherit system; };
        mach = import mach-nix { inherit pkgs python; };

        pyop = pyoperon.packages.${system}.default;
        pyEnv = mach.mkPython {
          requirements = ''
            matplotlib
            numpy
            pandas
            scikit-learn
            optuna
            joblib
            sympy
            pyyaml
            pathos
          '';

          ignoreDataOutdated = true;
        };
      in {
        devShell = mach.nixpkgs.mkShell {

          buildInputs = [ pyEnv pyop ];

          shellHook = ''
            export PYTHONPATH=$PYTHONPATH:${pyop}
          '';
        };
      });
}
