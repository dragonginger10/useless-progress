{
  description = "A Nix-flake-based Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [
        (self: super: {
          python = super.python311;
        })
      ];

      pkgs = import nixpkgs {inherit overlays system;};
    in {
      formatter = pkgs.alejandra;

      devShells.default = pkgs.mkShell {
        packages = with pkgs;
          [python]
          ++ (with pkgs.python310Packages; [pip tqdm setuptools]);

        shellHook = ''
          ${pkgs.python}/bin/python --version
        '';
      };

      packages = rec {
        default = progbar;

        progbar = with pkgs.python310Packages;
          buildPythonApplication {
            pname = "progbar";
            version = "1.1.4";
            format = "pyproject";

            propagatedBuildInputs = [tqdm setuptools];

            src = ./.;

            postinstall = ''
              mv -v ./progbar/phrases.txt $out/bin/phrases.txt
            '';
          };
      };
    });
}
