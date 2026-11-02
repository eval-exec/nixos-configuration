# nixos-configuration

NixOS and Home Manager configuration for `Mufasa`.

The default graphical session is **Umbriel + Noctalia v5**. Home Manager manages
both configurations in `modules/home/umbriel.nix`; NixOS registers the session and
its screen-sharing portal. Plasma remains available in SDDM as a fallback.

After rebuilding, log out and select **Umbriel** in SDDM (a remembered session may
override the default). `Super` opens the launcher, `Super+Return` opens Kitty,
`Super+S` opens Emacs, `Super+Ctrl+L` locks the screen, and `Super+Escape` logs out.
`Super+O` opens the overview; `Super+1` through `Super+9` select workspaces.
Noctalia's settings UI can override its Home Manager defaults; compositor settings
stay declarative, with an optional generated Noctalia color theme.

Noctalia uses the existing NetworkManager, Bluetooth, PipeWire, and UPower services.
Power profiles continue to use the machine's ACPI policy in `modules/nixos/power.nix`.

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
