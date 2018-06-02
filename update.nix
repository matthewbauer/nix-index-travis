let inherit (builtins) fromJSON fetchurl readFile toJSON toFile getEnv replaceStrings; in

{ hostPkgs ? import <nixpkgs> {}
, github ? fromJSON (readFile ./nixpkgs.json) }:

let
  inherit (hostPkgs) runCommand nix cacert writeText;
  commit-json = fetchurl "https://api.github.com/repos/${github.owner}/${github.repo}/commits/HEAD";
  commit = fromJSON (readFile commit-json);
  rev = commit.sha;
  sha256 = replaceStrings ["\n"] [""] (readFile (runCommand "sha256" { buildInputs = [ nix ]; } ''
export NIX_REMOTE=${getEnv "NIX_REMOTE"}
export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
nix-prefetch-url --unpack https://github.com/${github.owner}/${github.repo}/archive/${rev}.tar.gz > $out
''));
in
  writeText "github.json" (toJSON {
    inherit (github) repo owner;
    inherit sha256 rev;
  })
