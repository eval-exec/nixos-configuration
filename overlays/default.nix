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

    linux-manual = prev.linux-manual.overrideAttrs (old: {
      nativeBuildInputs = [
        prev.perl
        prev.python3
      ];
      postPatch = ''
        chmod +x scripts/kernel-doc.py scripts/split-man.pl
        patchShebangs --build \
          scripts/kernel-doc.py \
          scripts/split-man.pl
      '';
    });

    tmux = prev.tmux.overrideAttrs (oldAttrs: {
      NIX_CFLAGS_COMPILE = "-v";
      CFLAGS = (oldAttrs.CFLAGS or "") + " -O3 -flto -march=native";
    });

    mailspring = prev.mailspring.overrideAttrs (oldAttrs: {
      src = final.fetchurl {
        url = "https://github.com/Foundry376/Mailspring/releases/download/1.16.0/mailspring-1.16.0-amd64.deb";
        hash = "sha256-iJ6VzwvNTIRqUq9OWNOWOSuLbqhx+Lqx584kuyIslyA=";
      };

    });

    webkitgtk = prev.webkitgtk.overrideAttrs (oldAttrs: {
      version = "2.41.91";
      src = final.fetchurl {
        url = "https://webkitgtk.org/releases/webkitgtk-2.41.91.tar.xz";
        hash = "sha256-8o9rlbk5w/0gutIbGqni6s2jYhYl31tIAURRfMoCj0Y=";
      };
      buildInputs = oldAttrs.buildInputs ++ [
        final.libwpe
        final.libwpe-fdo
      ];
    });

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

  # Emacs overlay from nix-community
  emacs-overlay = inputs.emacs-overlay.overlays.default;
}
