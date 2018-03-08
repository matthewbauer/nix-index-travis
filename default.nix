{ nixpkgs ? <nixpkgs> }:
with import nixpkgs {};

runCommand "nix-index" {buildInputs = [nix-index nixStable];} ''
  export NIX_REMOTE=${builtins.getEnv "NIX_REMOTE"}
  mkdir p $out
  nix-index -d $out -f ${nixpkgs}
''
