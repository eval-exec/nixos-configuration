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
    glibc
    libgcc
    # These wrappers all install cc, ld, and ar. The user profile rejects that
    # collision; the system profile keeps every one of them.
    clang
    clang_multi
    gcc
    nvidia-container-toolkit
    nvidia-container-toolkit.tools
    libnvidia-container
    qt6.qtwebsockets
    kdePackages.qtwebsockets
    kdePackages.qtmultimedia
    glibcInfo
    interception-tools
    libclang
    libcxx
    libvterm
    man-pages-posix
    wireplumber
    ncurses5
    openssl
    pciutils
    polkit
    qemu
    scheme-manpages
    stdmanpages
    steam-run
    sysfsutils
    vim
    xfsprogs
    libxcb
    libxcb-util
    libxcb-image
    libxcb-wm
    config.boot.kernelPackages.turbostat
  ];
}
