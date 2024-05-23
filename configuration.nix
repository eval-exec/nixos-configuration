# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# test suda sudoa
{
  config,
  pkgs,
  inputs,
  lib,
  fetchurl,
  pkgs-stable,
  pkgs-vmware,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    # ./hardware-configuration.nix
    # <home-manager/nixos>
    ./cachix.nix
    ./g810-led.nix
  ];

  # sops = {
  #   gnupg = {
  #     home = "/home/exec/.gnupg";
  #     sshKeyPaths = [ ];
  #   };
  #   defaultSopsFile = ./secrets.yaml;
  #   secrets."google/execvy/application_password" = {
  #     owner = config.users.users.nobody.name;
  #     group = config.users.users.nobody.group;
  #   };
  # };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    # Bootloader.
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';

    tmp = {
      useTmpfs = false;
      # tmpfsSize = "50%";
      cleanOnBoot = true;
    };
  };
  console.useXkbConfig = true;

  documentation = {
    enable = true;
    dev.enable = true;
  };

  networking = {
    hostName = "Mufasa"; # Define your hostname.
    extraHosts = ''
      127.0.0.1 localhost
    '';
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager = {
      enable = true;
      dns = "none";
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    firewall = {
      enable = false;
      # allowedTCPPortRanges = [{
      #   from = 0;
      #   to = 65535;
      # }];
      # allowedUDPPortRanges = [{
      #   from = 0;
      #   to = 65535;
      # }];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;

        addons = with pkgs; [
          fcitx5-rime
          fcitx5-chinese-addons
          fcitx5-with-addons
          fcitx5-configtool
          fcitx5-gtk
          libsForQt5.fcitx5-qt
        ];
      };
    };
  };
  # specialisation = {
  #   internal_nvidia = {
  #     configuration = { services.xserver.videoDrivers = [ "nvidia" ]; };
  #   };
  # };

  services = {
    desktopManager = {
      plasma6.enable = true;
    };

    samba = {
      enable = true;
      shares = {
        public = {
          path = "/home/exec/Temp/samba";
          browseable = true;
          writable = true;
          printable = false;
          createMask = "0777";
        };
      };
    };
    flatpak = {
      enable = true;
    };
    guix = {
      enable = false;
    };
    fprintd = {
      enable = false;
    };
    keyd = {
      enable = false;
      keyboards.default.settings = {
        main = {
          capslock = "layer(control)";
          leftcontrol = "layer(hyper)";
        };
        "hyper:C-M-A" = { };
      };
    };
    # input-remapper = {
    #   enable = false;
    #   enableUdevRules = false;
    # };
    touchegg = {
      enable = true;
    };

    acpid = {
      enable = true;
      logEvents = true;
    };

    logind.extraConfig = ''
      RuntimeDirectorySize=16G
    '';

    thermald.enable = false;
    thermald.debug = true;

    # Enable the X11 windowing system.

    # services.nix-serve = {
    #   enable = true;
    #   # secretKeyFile = "/var/cache-priv-key.pem";
    # };

    # udev = { extraRules = "\n"; };

    resolved = {
      enable = false;
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
    displayManager = {

      defaultSession = "plasma";

      sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = false;
        user = "exec";
      };
    };

    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    libinput.touchpad.scrollMethod = "twofinger";
    libinput.touchpad.disableWhileTyping = true;
    libinput.touchpad.accelSpeed = "0.5"; # null

    # Configure keymap in X11
    xserver = {
      enable = true;
      xkb = {
        model = "pc104";
        layout = "us";
        variant = "";
        options = "ctrl:nocaps";
        extraLayouts = {
          ctrl = {
            description = "Caps as Ctrl, Ctrl as Hyper as Mod3";
            languages = [ "eng" ];
            symbolsFile = pkgs.writeText "ctrl" ''
              // Eliminate CapsLock, making it another Ctrl.
              partial modifier_keys
              xkb_symbols "nocaps" {
                  replace key <CAPS> { [ Control_L ], type[group1] = "ONE_LEVEL" };
                  modifier_map Control { <CAPS> };

                  modifier_map Mod4 { Super_L, Super_R };

                  key <SUPR> {    [ NoSymbol, Super_L ]   };
                  modifier_map Mod4   { <SUPR> };

                  replace key <LCTL> { [ Hyper_L ] };
                  modifier_map Mod3    { <LCTL> };

                  key <HYPR> {    [ NoSymbol, Hyper_L ]   };
                  modifier_map Mod3   { <HYPR> };
              };
            '';
          };
        };
      };

      videoDrivers = [ "nvidia" ];

      #   config = lib.mkAfter ''
      #     Section "Module"
      #         Load           "modesetting"
      #     EndSection

      #     Section "Device"
      #         Identifier     "amdgpu"
      #         Driver         "amdgpu"
      #         BusID          "PCI:9@0:0:0"
      #         Option         "AllowEmptyInitialConfiguration"
      #         Option         "AllowExternalGpus" "True"
      #     EndSection

      #     Section "Screen"
      #         Identifier "Screen-amdgpu[0]"
      #     	  Device "amdgpu"
      #     EndSection

      #     Section "Device"
      #     	  Identifier "Screen0"
      #     	  Driver "modesetting"
      #     	  BusId "PCI:0:2:0"
      #     EndSection

      #     Section "Screen"
      #         Identifier "eDP-1-1"
      #         Monitor "eDP-1-1"
      #         Device "Screen0"
      #     EndSection
      #   '';

      # Enable touchpad support (enabled default in most desktopManager).

      # Enable the KDE Plasma Desktop Environment.
      displayManager = {
        gdm.enable = false;
        # xserverArgs = [ "-verbose" "-logverbose" ];
        # setupCommands = "";
        # sessionCommands run before setupCommands
        # sessionCommands =
        #   "${pkgs.xorg.setxkbmap}/bin/setxkbmap -verbose 10 -layout us-mine";
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  security = {
    rtkit.enable = true;
    pam.services.sddm.enableKwallet = true;
    pam.services.kdewallet = {
      name = "kdewallet";
      enableKwallet = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.exec = {
    isNormalUser = true;
    description = "exec";
    useDefaultShell = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "vboxusers"
    ];
    packages = with pkgs; [
      firefox
      kate
    ];
  };
  users.defaultUserShell = pkgs.zsh;
  virtualisation = {
    # libvirtd.enable = true;
    # xen.enable = false;
    # waydroid.enable = false;

    virtualbox = {
      host = {
        enable = false;
        # package = pkgs-stable.virtualbox;
        enableExtensionPack = true;
      };
      guest.enable = false;
    };
    docker = {
      enable = true;
    };
    vmware = {
      host = {
        enable = false;
        package = pkgs-vmware.vmware-workstation;
      };
    };
  };

  users.extraUsers.exec.extraGroups = [ "libvirtd" ];

  users.extraGroups.vboxusers.members = [ "exec" ];

  # home-manager = {
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  #   users.exec = import ./home.nix;
  # };

  # Allow unfree packages
  fonts = {
    # fontDir = {
    #   enable = false;
    #   decompressFonts = true;
    # };
    enableDefaultPackages = false;
    packages = with pkgs; [
      iosevka
      jetbrains-mono
      julia-mono
      powerline-fonts
      powerline-symbols
      liberation_ttf
      nerdfonts
      # noto-fonts
      # google-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # noto-fonts-lgc-plus
      noto-fonts-color-emoji
      twemoji-color-font
      twitter-color-emoji
      # unicode-emoji
      # noto-fonts-extra
      sarasa-gothic
      source-han-sans
      source-han-serif
      symbola
      unifont
      vistafonts-chs
      vistafonts-chs
      vistafonts
      material-icons
      # material-design-icons
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif"
          "Noto Color Emoji"
          "Twitter Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Color Emoji"
          "Twitter Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
          "Twitter Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
          "Twitter Color Emoji"
        ];
      };
      # localConf = ''
      #   <?xml version='1.0' encoding='UTF-8'?>
      #   <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      #   <fontconfig>
      #    <alias>
      #     <family>serif</family>
      #     <prefer>
      #      <family>Noto Sans</family>
      #      <family>Noto Color Emoji</family>
      #     </prefer>
      #    </alias>
      #    <alias>
      #     <family>sans-serif</family>
      #     <prefer>
      #      <family>Noto Sans</family>
      #      <family>Noto Color Emoji</family>
      #     </prefer>
      #    </alias>
      #    <alias>
      #     <family>monospace</family>
      #     <prefer>
      #      <family>Noto Sans</family>
      #      <family>Noto Color Emoji</family>
      #     </prefer>
      #    </alias>
      #    <dir>~/.fonts</dir>
      #    <match target="font">
      #     <edit name="hinting" mode="assign">
      #      <bool>true</bool>
      #     </edit>
      #    </match>
      #    <match target="font">
      #     <edit name="hintstyle" mode="assign">
      #      <const>hintslight</const>
      #     </edit>
      #    </match>
      #   </fontconfig>
      # '';
    };
  };

  environment = {
    # sessionVariables = {
    # };
    variables = {
      # XKB_DEFAULT_LAYOUT = "us";
      # NIXOS_OZONE_WL = "1";
      # GDK_BACKEND = "wayland";
      GTK_IM_MODULE = lib.mkForce "";
      QT_IM_MODULE = lib.mkForce "";
      EDITOR = "nvim";
      VISUAL = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    };
    localBinInPath = true;
    pathsToLink = [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "electron-11.5.0"
        "electron-24.8.6"
        "electron-25.9.0"
        "electron-19.1.9"
      ];
      vivaldi = {
        proprietaryCodecs = true;
        enableWideVine = true;
      };
    };

    # overlays = [ emacs-overlay.overlay ];
  };

  environment.systemPackages = with pkgs; [
    linuxHeaders
    libsForQt5.xdg-desktop-portal-kde
    kdePackages.kde-gtk-config
    kdePackages.discover
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    appimage-run
    cachix
    clang
    docker-compose
    dua
    duf
    file
    git
    gnome3.gnome-tweaks
    glibcInfo
    gnumake
    interception-tools
    libclang
    libcxx
    libvterm
    linux-manual
    lldb
    man-pages-posix
    man-pages-posix
    wireplumber
    ncurses
    neovim
    nodejs
    openssl
    openssl_1_1
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
    stdman
    stdmanpages
    steam-run
    sysfsutils
    tdesktop
    tdrop
    tree
    vim
    wakatime
    wget
    xclip
    xdotool
    xfsprogs
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilwm
    xorg.xdpyinfo
    xorg.xev
    xorg.xkbcomp
    xorg.xmodmap
    xorg.xwininfo
    zlib
    # nvidia-vaapi-driver
  ];
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "exec"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];

      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  programs.xwayland.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.fish.enable = false;
  programs.zsh.enable = true;
  programs.wshowkeys.enable = true;
  programs.virt-manager.enable = true;

  programs.wayfire = {
    enable = false;
    plugins = (
      with pkgs.wayfirePlugins;
      [
        wcm
        wf-shell
        wayfire-plugins-extra
      ]
    );
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          wqy_zenhei
          wqy_microhei
        ];

      extraProfile = "export STEAM_FORCE_DESKTOPUI_SCALING=2";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      sqlite
      libaio
      pcsclite

      fuse3
      fuse
      libgccjit
      libgit2
      boost
      libevent
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libcxx
      libGL
      libappindicator-gtk3
      libdrm
      libkrb5
      libnotify
      libpulseaudio
      libuuid
      libusb1
      libxkbcommon
      mesa
      nspr
      nss
      pango
      pipewire
      systemd
      icu
      openssl
      openssl_1_1
      xcb-util-cursor
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libxkbfile
      xorg.libXrandr
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libxshmfence
      xorg.libXtst
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilrenderutil
      xorg.xcbutilkeysyms
      xorg.xcbutilerrors
      xorg.xcbutil

      zlib
    ];
  };
  programs.htop.enable = true;
  programs.mosh.enable = true;

  systemd = {
    services = {
      sunshine = {
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          User = "root";
          ExecStart = "${pkgs.sunshine}/bin/sunshine";
        };
      };
      # disable_cpu_turbo = {
      #   wantedBy = [ "sysinit.target" ];
      #   serviceConfig = {
      #     Type = "oneshot";
      #     User = "root";
      #     ExecStart = ''/bin/sh -c "echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
      #     ExecStop = ''/bin/sh -c "echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo"'';
      #     RemainAfterExit = true;
      #   };
      # };
    };
  };
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
