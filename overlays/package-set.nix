{ inputs }:
let
  overlays = import ./default.nix { inherit inputs; };
in
{
  inherit overlays;

  # Applied once, then shared by the NixOS configuration and standalone
  # Home Manager. NixOS rejects nixpkgs.pkgs together with nixpkgs.overlays.
  pkgsOverlays = [
    overlays.additions
    overlays.modifications
    overlays.unstable-packages
    overlays.emacs-overlay
    inputs.nix-alien.overlays.default
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  config = {
    allowUnfree = true;
    cudaSupport = false;
    permittedInsecurePackages = [
      "electron-11.5.0"
      "electron-24.8.6"
      "electron-25.9.0"
      "electron-19.1.9"
      "electron-28.3.3"
      "electron-27.3.11"
      "electron-32.3.3"
      "electron-39.8.10"
    ];
    vivaldi = {
      proprietaryCodecs = true;
      enableWideVine = true;
    };
    nvidia.acceptLicense = true;
  };
}
