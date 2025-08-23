#!/bin/sh

FLAKE_PATH=$(dirname "$(readlink -f "$0")")
echo "\"$FLAKE_PATH\"" > .flakeroot.nix

if [[ "$OSTYPE" = "linux-gnu"* ]];
then
    sudo nixos-rebuild switch --flake path:$FLAKE_PATH
elif [[ "$OSTYPE" = "darwin"* ]];
then
    sudo darwin-rebuild switch --flake path:$FLAKE_PATH
else
    echo "Unsupported OS"
    exit 1
fi
