# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    # Add -O3 -mtune=native -march=native to CFLAGS for emacs-git
    emacs-git = prev.emacs-git.overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [
        "-O3"
        "-mtune=native"
        "-march=native"
      ];
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nur-packages = final: _prev: {
    nur = import inputs.nur {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
