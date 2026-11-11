# Emacs source-build shell. Installed as `gnu-emacs-dev`.
# ~/.config/emacs/default.nix imports this same function, so nix-shell keeps working.
{
  pkgs,
  homeDirectory,
}:
pkgs.mkShell {
  hardeningDisable = [ "all" ];
  nativeBuildInputs = with pkgs; [
    cmake
    libevent
    libtool
    boost
    pkg-config
    libotf
    libcxx
    clang-tools
  ];

  buildInputs = with pkgs; [
    guile
    pkg-config
    libllvm
    openssl
    libotf
    nss
    sqlite
    glib
    gmime3
    xapian
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-vaapi

    sealcurses
    mesa
    librsvg
    ncurses
    libXcursor
    ncurses5
  ];

  LIBRARY_PATH = "${pkgs.libgccjit}/lib/gcc:${pkgs.stdenv.cc.libc}/lib:${pkgs.stdenv.cc.cc.libgcc}/lib:${pkgs.libgccjit}/bin";
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.libotf ];
  OLLAMA_API_BASE = "http://127.0.0.1:11434";

  shellHook = ''
    export INFOPATH=${homeDirectory}/Projects/github.com/emacs-mirror/build/share/info:$INFOPATH
    export LSP_USE_PLISTS=true
    export LC_COLLATE=C
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn,direct
    export BASH_IDE_LOG_LEVEL=debug
    export PATH=${homeDirectory}/.local/bin:${homeDirectory}/Projects/github.com/emacs-mirror/build/bin:$PATH
    export GTK_IM_MODULE=fcitx
    export DICTIONARY=en_US
    export OPENAI_API_KEY=$(cat ${homeDirectory}/.config/openai_api_key/key.private)
    export GEMINI_API_KEY=$(cat ${homeDirectory}/.config/gemini.private)
    export CODESTRAL_API_KEY=$(cat ${homeDirectory}/.config/mistral/api.private)
    export DEEPSEEK_API_KEY=$(cat ${homeDirectory}/.config/deepseek.private)
    export AIDER_CHECK_UPDATE=false
    export AIDER_MODEL=gemini/gemini-2.5-pro-preview-06-05
    export GDK_BACKEND=x11
    export XCURSOR_SIZE=32
    source ${homeDirectory}/.emacs.d/.venv/bin/activate
    export WAYLAND_DEBUG=0
  '';
}
