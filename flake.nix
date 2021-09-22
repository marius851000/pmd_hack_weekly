{
  inputs.nixpkgs.url = "nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gitignore_src = {
    url = "github:hercules-ci/gitignore.nix";
    flake = false;
  };
  outputs = { self, nixpkgs, flake-utils, gitignore_src}:
    (
      flake-utils.lib.eachSystem flake-utils.lib.allSystems (
        system:
          let
            pkgs = import nixpkgs {
              inherit system;
            };

            gitignore = import gitignore_src {
              lib = pkgs.lib;
            };

            pythonPackage = pkgs.python3Packages;

            yamlns = pythonPackage.buildPythonPackage rec {
              pname = "yamlns";
              version = "0.9.1";

              src = pythonPackage.fetchPypi {
                inherit pname version;
                sha256 = "sha256-3LDzPmxboU6cRia9Q4b92VZIYpzYTLVZNGday7KiO2g=";
              };

              propagatedBuildInputs = with pythonPackage; [
                pyyaml
                nose
                rednose
              ];
            };

            markdown-customblocks = pythonPackage.buildPythonPackage rec {
              pname = "markdown-customblocks";
              version = "1.1.1";
              src = pythonPackage.fetchPypi {
                inherit pname version;
                sha256 = "sha256-ZKDjSTog7qbemwV/YQGSBF2lwmRuNZwBomSW6ND6SM4=";
              };

              propagatedBuildInputs = with pythonPackage; [
                decorator
                beautifulsoup4
                responses
                markdown
                yamlns
                pytest
              ];

              doCheck = false;
            };

            site = pkgs.stdenv.mkDerivation {
              name = "this-week-in-pmd-hacking";
              #disable, as it crash the raspi
              #src = gitignore.gitignoreSource ./.;
              src = ./.;
              buildInputs = with pkgs.python3Packages; [
                pelican
                markdown
                markdown-customblocks
              ];
              buildPhase = ''
                pelican
              '';
              installPhase = ''
                mkdir $out
                cp -r ./output/* $out
              '';
            };
          in
            {
              packages = {
                inherit site;
              };
            }
      )
    );
}
