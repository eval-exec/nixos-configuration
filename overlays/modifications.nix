final: prev: {
  linux-manual = prev.linux-manual.overrideAttrs (_old: {
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

  mailspring = prev.mailspring.overrideAttrs (_oldAttrs: {
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

  libwpe-fdo = prev.libwpe-fdo.overrideAttrs (_oldAttrs: {
    version = "1.16.1";
    src = final.fetchurl {
      url = "https://wpewebkit.org/releases/wpebackend-fdo-1.16.1.tar.xz";
      hash = "sha256-VErhQBL45+QmuMtSLrCqqsgxrXw1YB0c8x03Zw4Ouzs=";
    };
  });
}
