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

    # # Use the master branch of bluez/bluez
    # unstable.bluez = prev.bluez.overrideAttrs (oldAttrs: {
    #   src = final.fetchFromGitHub {
    #     owner = "bluez";
    #     repo = "bluez";
    #     rev = "d9430c0635bc36177d521d62a51f0d2a4e8c0fbb";
    #     sha256 = "sha256-TvfnhAFdyPtLYip7GaSIoXDsZAjcjd251l75JMbg52I=";
    #   };

    #   # # Add required build inputs for building from git
    #   # nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
    #   #   final.autoconf
    #   #   final.automake
    #   #   final.libtool
    #   #   final.pkg-config
    #   # ];

    #   # # Need to run autogen.sh when building from git
    #   # preConfigure = ''
    #   #   ./autogen.sh
    #   # '';
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
