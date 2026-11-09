{ pkgs, ... }:
{
  programs = {
    ydotool.enable = true;
    xwayland.enable = true;
    criu.enable = true;
    noisetorch.enable = true;
    fish.enable = false;
    zsh = {
      enable = true;
      enableCompletion = false;
      promptInit = "";
      setOptions = [ ];
    };
    wshowkeys.enable = true;

    wayfire = {
      enable = false;
      plugins = with pkgs.wayfirePlugins; [
        wcm
        wf-shell
        wayfire-plugins-extra
      ];
    };

    steam = {
      enable = true;
      # Steam's bundled SDL3 picks the Wayland EGL backend, which segfaults in
      # NVIDIA's libnvidia-egl-wayland2 (driver 595) and makes steamwebhelper
      # crash-loop. Run the client through XWayland instead.
      package = pkgs.steam.override { extraEnv.SDL_VIDEODRIVER = "x11"; };
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        alsa-lib
        libxshmfence
        ncurses6
        libselinux
        gnutls
        e2fsprogs
        gmp
        tree-sitter
        gtk4
        harfbuzz
        graphene
        libwpe
        libwpe-fdo
        at-spi2-atk
        at-spi2-core
        atk
        boost
        cairo
        cups
        libsoup_3
        curl
        dbus
        expat
        fontconfig
        fribidi
        freetype
        fuse
        fuse3
        gcc-unwrapped.lib
        gdk-pixbuf
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gstreamer

        glib
        glibc
        glibc_multi
        gtk3
        icu
        libGL
        libaio
        libappindicator-gtk3
        libcxx
        libdrm
        libevent
        libgcc
        libgccjit
        libgit2
        libgbm
        libgpg-error
        libkrb5
        libnotify
        libpulseaudio
        libusb1
        libuuid
        libxkbcommon
        libxml2
        mesa
        mpv
        nspr
        nss
        openssl
        pango
        pcsclite
        rocksdb
        sqlite
        stdenv.cc.cc.lib
        systemd
        vulkan-loader
        wayland
        xcb-util-cursor
        libx11
        libxscrnsaver
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxrandr
        libxrender
        libxtst
        libxcb
        libxkbfile
        libxshmfence
        libxcb-util
        libxcb-errors
        libxcb-image
        libxcb-keysyms
        libxcb-render-util
        libxcb-wm
        zlib-ng
      ];
    };
    mosh.enable = true;
  };

  xdg.portal.xdgOpenUsePortal = true;
}
