{
    inputs.nixpkgs.url = "nixpkgs";
    inputs.flake-utils.url = "github:numtide/flake-utils";
    inputs.gitignore_src = {
        url = "github:hercules-ci/gitignore.nix";
        flake = false;
    };
    outputs = { self, nixpkgs, flake-utils, gitignore_src }:
    (
        flake-utils.lib.eachSystem flake-utils.lib.allSystems (system:
            let 
                pkgs = import nixpkgs {
                    inherit system;
                };

                gitignore = import gitignore_src {
                    lib = pkgs.lib;
                };
                

                site = pkgs.stdenv.mkDerivation {
                    name = "this-week-in-pmd-hacking";
                    src = gitignore.gitignoreSource ./.;

                    buildInputs = with pkgs.python3Packages; [
                        pelican
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
                    inherit site;
                };
            }
        )
    );
}