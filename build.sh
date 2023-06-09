#!/usr/bin/env bash
set -e
nixfmt *.nix

git diff --exit-code

sudo nixos-rebuild switch --flake /home/exec/my-flake/.#Mufasa --verbose
