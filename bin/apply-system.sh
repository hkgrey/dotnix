#!/bin/sh

pushd ~/.config/dotnix
# home-manager switch --flake .#hkailahi
# nix run nix-darwin -- switch --flake ~/.config/dotnix "$@"
sudo -H $(which darwin-rebuild) switch --flake .
popd
