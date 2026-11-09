{ config, pkgs, ... }:
{
  fonts = {
    fontDir = {
      enable = true;
      decompressFonts = true;
    };
    enableDefaultPackages = true;
    packages = with pkgs; [
      symbola
      iosevka
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      sarasa-gothic
      source-han-sans
      source-han-serif
      liberation_ttf
      ubuntu-classic
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      wqy_zenhei
      wqy_microhei
    ];
    fontconfig.enable = true;
  };

  environment = {
    wordlist.enable = true;
    localBinInPath = true;
    pathsToLink = [ ];
  };

  environment.systemPackages = with pkgs; [
    linuxHeaders
    kdePackages.xdg-desktop-portal-kde
    perf
    kdePackages.kde-gtk-config
    kdePackages.qtvirtualkeyboard
    kdePackages.plasma-sdk
    kdePackages.qtwebengine
    kdePackages.discover
    tailscale
    xdg-desktop-portal
    xdg-utils
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    appimage-run
    cachix
    gpu-screen-recorder # CLI
    gpu-screen-recorder-gtk # GUI
    clang
    clang_multi
    wlrctl
    glibc
    glibc_multi
    gcc
    libgcc
    (aspellWithDicts (
      ds: with ds; [
        en
        en-computers
        en-science
      ]
    ))
    docker-compose
    nvidia-container-toolkit
    nvidia-container-toolkit.tools
    libnvidia-container
    nix-alien

    qt6.qtwebsockets
    kdePackages.qtwebsockets
    wayland-utils
    vulkan-tools
    easyeffects
    kdePackages.qtmultimedia
    gst_all_1.gst-libav
    dua
    duf
    file
    git
    git-lfs
    glibcInfo
    gnumake
    interception-tools
    libclang
    libcxx
    libvterm
    lldb
    man-pages-posix
    wireplumber
    ncurses
    ncurses5
    nodejs
    openssl
    pciutils
    pinentry-curses
    pinentry-emacs
    pinentry-qt
    pkg-config
    polkit
    proxychains-ng
    python3
    qemu
    scheme-manpages
    stdmanpages
    steam-run
    sysfsutils
    telegram-desktop
    tdrop
    tree
    vim
    tesseract
    wakatime-cli
    wget
    xclip
    xdotool
    xfsprogs
    libxcb
    xhost
    libxcb-util
    libxcb-image
    libxcb-wm
    xdpyinfo
    xev
    xkbcomp
    xmodmap
    xwininfo
    zlib-ng
    config.boot.kernelPackages.turbostat
  ];
}
