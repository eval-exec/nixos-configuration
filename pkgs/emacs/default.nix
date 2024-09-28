{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "emacs";
  version = "master";

  src = fetchFromGitHub {
    owner = "emacs-mirror";
    repo = "emacs";
    rev = "bba14a27678317eee68e87a343e7314b3949f6c7";
    hash = "sha256-POoudgSF2VpAN2FmlkwTI6wvWPxfQDaXl/gGu/VYxvI=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Emacs build with -O3";
    longDescription = ''
      Emacs build in master branch, with O3 optimization.
    '';
    homepage = "https://www.gnu.org/software/emacs/";
    changelog = "https://github.com/emacs-mirror/emacs/commits/master/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
  nativeBuildInputs = with pkgs; [
    gcc
    clang
  ];
  buildInputs = with pkgs; [
    pkg-config
    autoconf
    ncurses
    libseccomp
    glib
    openssl
    jansson
    acl
    attr
    liburing
    gnutls
    webkitgtk
    xorg.libX11
    xorg.libXaw
    libotf
    librsvg
    gtk3
    xorg.libXpm
    giflib
    tree-sitter
    xorg.libXext
    libgccjit
    libcxx
    zlib
    texinfo
    imagemagick
  ];
  preConfigure = ''
    export CFLAGS='-O3 -mtune=native -march=native'
  '';
  configureFlags = [
    "--with-imagemagick"
    "--with-modules"
    "--with-cairo"
    "--with-cairo-xcb"
    "--without-compress-install"
    "--with-native-compilation"
    "--with-mailutils"
    "--enable-link-time-optimization"
    "--with-tree-sitter"
    "--with-xinput2"
    "--with-dbus"
    "--with-native-compilation=aot"
    "--with-file-notification=inotify"
  ];
  enableParallelBuilding = true;

  # installPhase = ''
  #   make install DESTDIR=$out
  # '';

}
