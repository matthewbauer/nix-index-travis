#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq curl

head=$(curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/NixOS/nixpkgs-channels/commits/nixpkgs-unstable | jq -r .sha)
sha256=$(nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/$head.tar.gz)
echo '{"owner":"NixOS","repo":"nixpkgs-channels","rev":"'$head'","sha256":"'$sha256'"}' > nixpkgs.json
