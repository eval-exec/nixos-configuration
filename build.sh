#!/usr/bin/env bash
set -e
alejandra *.nix

git diff --exit-code

sudo nixos-rebuild switch --flake /home/exec/my-flake/.#Mufasa --verbose
