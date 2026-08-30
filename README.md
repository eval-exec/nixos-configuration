# nixos-configuration

NixOS and Home Manager configuration for `Mufasa`.

## Layout

```text
hosts/Mufasa/       machine identity and hardware configuration
homes/exec/         Home Manager composition root for exec
modules/nixos/      reusable system features
modules/home/       reusable user-environment features
overlays/           package-set extensions and overrides
pkgs/               custom packages
secrets/            SOPS-encrypted secrets
```

The host and home entrypoints are intentionally thin. They select cohesive modules; machine- or user-specific values stay at their respective composition roots.

## Commands

```sh
make fmt        # format every Nix file
make check      # evaluate all flake checks
make dry-build  # evaluate and dry-build Mufasa
make switch-os  # activate NixOS and Home Manager together
make switch-hm  # activate only the primary user's Home Manager generation
make boot       # build and select the configuration for next boot
```

`system.stateVersion` and `home.stateVersion` describe compatibility with the original installation. Do not bump them as part of a normal NixOS upgrade.
