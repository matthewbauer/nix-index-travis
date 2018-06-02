{ nixpkgs ? hostPkgs.fetchFromGitHub
            (builtins.fromJSON (builtins.readFile ./nixpkgs.json))
, hostPkgs ? import <nixpkgs> {} }:

hostPkgs.runCommand "nix-index" {
  buildInputs = [ hostPkgs.nix-index hostPkgs.nix ];
} ''
  export NIX_REMOTE=${builtins.getEnv "NIX_REMOTE"}
  mkdir -p $out
  nix-index -d $out -f ${nixpkgs}
''
