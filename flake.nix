{
  inputs.nixpkgs.url = "nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gitignore_src = {
    url = "github:hercules-ci/gitignore.nix";
    flake = false;
  };
  inputs.pelimoji_src = {
    url = "github:pelican-plugins/pelimoji";
    flake = false;
  };
  inputs.glue_src = {
    url = "github:justinmayer/glue";
    flake = false;
  };
  outputs = { self, nixpkgs, flake-utils, gitignore_src, pelimoji_src, glue_src }:
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

            pelimoji = pythonPackage.buildPythonPackage {
              pname = "pelimoji";
              version = "git";

              format = "pyproject";

              prePatch = ''
                substituteInPlace pyproject.toml \
                    --replace '{ git = "https://github.com/justinmayer/glue.git" }' '"^0.13"'
              '';

              propagatedBuildInputs = with pythonPackage; [
                pelican
                glue
              ];

              nativeBuildInputs = with pythonPackage; [
                poetry
              ];

              src = pelimoji_src;
            };
                
            glue = pythonPackage.buildPythonPackage {
              pname = "glue";
              version = "git";

              propagatedBuildInputs = with pythonPackage; [
                pillow
                jinja2
              ];

              doCheck = false;

              src = glue_src;
            };

            site = pkgs.stdenv.mkDerivation {
              name = "this-week-in-pmd-hacking";
              src = gitignore.gitignoreSource ./.;

              buildInputs = with pkgs.python3Packages; [
                pelican
                pelimoji
                markdown
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
                inherit site pelimoji glue;
              };
            }
      )
    );
}
