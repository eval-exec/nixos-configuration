{
  stdenv,
  pkgs,
  lib,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  makeWrapper,
  electron,
  gtk3,
  glib,
  libsecret,
  nss,
  nspr,
  gdk-pixbuf,
  cairo,
  pango,
  atk,
  at-spi2-atk,
  at-spi2-core,
  dbus,
  libxcb,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libXi,
  libXcursor,
  libXtst,
  libxkbcommon,
  alsa-lib,
  cups,
  libgbm,
  mesa,
}:

stdenv.mkDerivation rec {
  pname = "min";
  version = "1.35.1";

  src = fetchurl {
    url = "https://github.com/minbrowser/min/releases/download/v${version}/min-${version}-amd64.deb";
    sha256 = "1nsnjlx371wgy3hl02fa5fc2gycnr10i3fhdhsz8ijr2baa09qlw";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    electron
    gtk3
    glib
    libsecret
    nss
    nspr
    gdk-pixbuf
    cairo
    pango
    atk
    at-spi2-atk
    at-spi2-core
    dbus
    pkgs.xorg.libxcb
    pkgs.xorg.libX11
    pkgs.xorg.libXcomposite
    pkgs.xorg.libXdamage
    pkgs.xorg.libXext
    pkgs.xorg.libXfixes
    pkgs.xorg.libXrandr
    pkgs.xorg.libXi
    pkgs.xorg.libXcursor
    pkgs.xorg.libXtst
    libxkbcommon
    alsa-lib
    cups
    mesa
    libgbm
    stdenv.cc.cc
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    mkdir -p $out/opt

    # Copy the application files
    cp -r usr/share/* $out/share/
    cp -r opt/Min $out/opt/

    # Create a wrapper script
    makeWrapper $out/opt/Min/min $out/bin/min \
      --prefix PATH : ${lib.makeBinPath [ electron ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}:${stdenv.cc.cc.lib}/lib

    # Create desktop entry
    substituteInPlace $out/share/applications/min.desktop \
      --replace "/opt/Min/min" "$out/bin/min"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A smarter, faster web browser";
    homepage = "https://minbrowser.github.io/min/";
    license = licenses.lgpl3;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
