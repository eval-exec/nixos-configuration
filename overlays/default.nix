{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = import ./modifications.nix;

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };

  emacs-overlay = inputs.emacs-overlay.overlays.default;
}
